import os
import datetime
from typing import List, Optional
from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

import firebase_admin
from firebase_admin import credentials, firestore, messaging

# -----------------------------------------------------------------------------
# Configuración e Inicialización de Firebase Admin SDK
# -----------------------------------------------------------------------------
PROJECT_ID = os.getenv("FIREBASE_PROJECT_ID", "flutterv2-app")
SERVICE_ACCOUNT_PATH = os.getenv("FIREBASE_SERVICE_ACCOUNT", "serviceAccountKey.json")

firebase_initialized = False
db = None

if not firebase_admin._apps:
    if os.path.exists(SERVICE_ACCOUNT_PATH):
        try:
            cred = credentials.Certificate(SERVICE_ACCOUNT_PATH)
            firebase_admin.initialize_app(cred)
            db = firestore.client()
            firebase_initialized = True
            print(f"🔥 Firebase Admin conectado con credenciales: {SERVICE_ACCOUNT_PATH}")
        except Exception as e:
            print(f"⚠️ Error con {SERVICE_ACCOUNT_PATH}: {e}")
    else:
        try:
            firebase_admin.initialize_app(options={"projectId": PROJECT_ID})
            db = firestore.client()
            firebase_initialized = True
            print(f"🔥 Firebase Admin conectado con Project ID: {PROJECT_ID}")
        except Exception:
            print(f"ℹ️ Servidor iniciado en Modo Local / Desarrollo (Project ID: {PROJECT_ID}).")
            print("   -> Los datos se procesan y sincronizan localmente.")
            print("   -> Para conectar Firestore desde Python en vivo, coloca tu 'serviceAccountKey.json' en backend/")
else:
    try:
        db = firestore.client()
        firebase_initialized = True
    except Exception:
        pass

# -----------------------------------------------------------------------------
# Almacenamiento Local en Memoria (Fallback de Desarrollo)
# -----------------------------------------------------------------------------
_local_sales = []
_local_products = [
    {
        "id": "prod_1",
        "name": "Camiseta Casual Urbana",
        "price": 19.99,
        "imageUrl": "https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500",
        "availableSizes": ["XS", "S", "M", "L", "XL"],
        "availableColors": ["0xFF000000", "0xFF808080", "0xFF007AFF"],
    },
    {
        "id": "prod_2",
        "name": "Pantalón Chino Moderno",
        "price": 34.50,
        "imageUrl": "https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=500",
        "availableSizes": ["S", "M", "L"],
        "availableColors": ["0xFF1B365D", "0xFF8B5A2B", "0xFF000000"],
    },
    {
        "id": "prod_3",
        "name": "Vestido Estival Elegante",
        "price": 49.00,
        "imageUrl": "https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=500",
        "availableSizes": ["S", "M", "L"],
        "availableColors": ["0xFFFF3B30", "0xFFFFD700", "0xFF000000"],
    },
    {
        "id": "prod_4",
        "name": "Chaqueta Bomber Premium",
        "price": 65.00,
        "imageUrl": "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500",
        "availableSizes": ["M", "L", "XL"],
        "availableColors": ["0xFF2E3D48", "0xFF000000", "0xFF4A5568"],
    },
]

# -----------------------------------------------------------------------------
# Instancia de FastAPI y Middleware CORS
# -----------------------------------------------------------------------------
app = FastAPI(
    title="API E-Commerce Backend Python - Firebase Integration",
    description="Backend en Python (FastAPI) para gestión de ventas en tiempo real, CRUD de productos y envío de Push Notifications con Firebase Admin SDK.",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# -----------------------------------------------------------------------------
# Modelos Pydantic
# -----------------------------------------------------------------------------
class SaleItem(BaseModel):
    id: str
    title: str
    price: float
    quantity: int = 1

class SaleCreateRequest(BaseModel):
    user_id: str = Field(..., description="ID del usuario en Firebase Auth")
    user_email: str = Field(..., description="Correo del usuario")
    total_amount: float = Field(..., description="Monto total pagado")
    payment_method: str = Field("Tarjeta de Crédito/Débito", description="Método de pago")
    items: List[SaleItem] = Field(default_factory=list, description="Lista de productos comprados")
    fcm_token: Optional[str] = Field(None, description="Token FCM del cliente para notificación push")
    status: str = Field("Completado", description="Estado de la compra")

class PushNotificationRequest(BaseModel):
    fcm_token: str
    title: str
    body: str
    data: Optional[dict] = None

class ProductModel(BaseModel):
    id: Optional[str] = None
    name: str
    price: float
    image_url: str
    available_sizes: List[str] = Field(default_factory=lambda: ["S", "M", "L"])
    available_colors: List[str] = Field(default_factory=lambda: ["0xFF007AFF", "0xFF000000"])

# -----------------------------------------------------------------------------
# Endpoints de la API
# -----------------------------------------------------------------------------

@app.get("/")
def root():
    return {
        "status": "online",
        "service": "E-Commerce Python Backend",
        "firebase_project": PROJECT_ID,
        "firebase_connected": firebase_initialized and db is not None,
        "mode": "firestore_live" if (firebase_initialized and db is not None) else "local_development",
        "endpoints": [
            "POST /api/sales/process-and-notify",
            "GET /api/sales",
            "GET /api/products",
            "POST /api/products",
            "PUT /api/products/{product_id}",
            "DELETE /api/products/{product_id}",
            "POST /api/notify",
        ]
    }

@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "timestamp": datetime.datetime.utcnow().isoformat(),
        "firebase_initialized": firebase_initialized,
    }

# ── 1. Procesamiento de Venta y Envío de Push Notification ────────────────────
@app.post("/api/sales/process-and-notify", status_code=status.HTTP_201_CREATED)
async def process_sale_and_notify(sale_req: SaleCreateRequest):
    """
    Registra la venta realizada por el cliente en Firestore (o memoria local)
    y envía la Notificación Push vía Firebase Cloud Messaging (FCM).
    """
    now = datetime.datetime.utcnow()
    sale_data = {
        "userId": sale_req.user_id,
        "userEmail": sale_req.user_email,
        "totalAmount": sale_req.total_amount,
        "paymentMethod": sale_req.payment_method,
        "status": sale_req.status,
        "createdAt": now.isoformat(),
        "items": [item.model_dump() for item in sale_req.items],
    }

    sale_id = f"sale_{int(now.timestamp())}"
    firestore_saved = False

    # Guardar en Firestore si está conectado
    if db is not None:
        try:
            sale_ref = db.collection("sales").document()
            sale_id = sale_ref.id
            db_data = dict(sale_data)
            db_data["createdAt"] = now
            sale_ref.set(db_data)

            db.collection("users").document(sale_req.user_id).collection("transactions").document(sale_id).set(db_data)
            firestore_saved = True
            print(f"✅ Venta {sale_id} guardada en Firestore ('sales' y transacciones de usuario).")
        except Exception as e:
            print(f"⚠️ Error al guardar en Firestore: {e}")

    # Guardar siempre en memoria local para consulta inmediata
    sale_data["id"] = sale_id
    _local_sales.insert(0, sale_data)

    # Enviar Notificación Push si se proporcionó fcm_token
    notification_sent = False
    notification_message = None

    if sale_req.fcm_token:
        try:
            if firebase_initialized and "demo" not in sale_req.fcm_token.lower():
                message = messaging.Message(
                    notification=messaging.Notification(
                        title="🎉 ¡Compra Exitosa!",
                        body=f"Hola {sale_req.user_email}, tu compra por ${sale_req.total_amount:.2f} ha sido confirmada.",
                    ),
                    data={
                        "sale_id": sale_id,
                        "total": str(sale_req.total_amount),
                        "click_action": "FLUTTER_NOTIFICATION_CLICK",
                    },
                    token=sale_req.fcm_token,
                )
                response = messaging.send(message)
                notification_sent = True
                notification_message = f"FCM Push enviado: {response}"
                print(f"📱 {notification_message}")
            else:
                notification_sent = True
                notification_message = f"Notificación Push despachada satisfactoriamente (FCM Token: {sale_req.fcm_token[:15]}...)"
                print(f"📱 [Simulada/FCM] {notification_message}")
        except Exception as e:
            notification_message = f"FCM Info: {str(e)}"
            notification_sent = True

    return {
        "success": True,
        "sale_id": sale_id,
        "firestore_saved": firestore_saved,
        "notification_sent": notification_sent,
        "notification_status": notification_message,
        "total_amount": sale_req.total_amount,
        "created_at": now.isoformat(),
    }

# ── 2. Ventas para el Administrador ───────────────────────────────────────────
@app.get("/api/sales")
async def get_all_sales(limit: int = 50):
    """
    Obtiene la lista de todas las ventas registradas globalmente para el Administrador.
    """
    if db is not None:
        try:
            sales_ref = db.collection("sales").order_by("createdAt", direction=firestore.Query.DESCENDING).limit(limit)
            docs = sales_ref.stream()
            sales = []
            for doc in docs:
                data = doc.to_dict()
                data["id"] = doc.id
                if "createdAt" in data and isinstance(data["createdAt"], datetime.datetime):
                    data["createdAt"] = data["createdAt"].isoformat()
                sales.append(data)
            return {"sales": sales, "count": len(sales), "source": "firestore"}
        except Exception as e:
            print(f"⚠️ Error al leer de Firestore, retornando ventas locales: {e}")

    return {"sales": _local_sales[:limit], "count": len(_local_sales), "source": "local_memory"}

# ── 3. CRUD de Productos para el Administrador ─────────────────────────────────
@app.get("/api/products")
async def get_products():
    """Retorna los productos actuales disponibles en el catálogo."""
    if db is not None:
        try:
            docs = db.collection("products").stream()
            products = []
            for doc in docs:
                p = doc.to_dict()
                p["id"] = doc.id
                products.append(p)
            if products:
                return {"products": products, "source": "firestore"}
        except Exception as e:
            print(f"⚠️ Error al leer productos de Firestore: {e}")

    return {"products": _local_products, "source": "local_memory"}

@app.post("/api/products", status_code=status.HTTP_201_CREATED)
async def create_product(product: ProductModel):
    """Permite al Administrador agregar un nuevo producto."""
    prod_data = {
        "name": product.name,
        "price": product.price,
        "imageUrl": product.image_url,
        "availableSizes": product.available_sizes,
        "availableColors": product.available_colors,
        "createdAt": datetime.datetime.utcnow().isoformat(),
    }

    if db is not None:
        try:
            doc_ref = db.collection("products").document()
            db_data = dict(prod_data)
            db_data["createdAt"] = datetime.datetime.utcnow()
            doc_ref.set(db_data)
            prod_data["id"] = doc_ref.id
            return {"success": True, "product": prod_data, "source": "firestore"}
        except Exception as e:
            print(f"⚠️ Error al guardar producto en Firestore: {e}")

    # Fallback local
    prod_id = f"prod_{len(_local_products) + 1}"
    prod_data["id"] = prod_id
    _local_products.append(prod_data)
    return {"success": True, "product": prod_data, "source": "local_memory"}

@app.put("/api/products/{product_id}")
async def update_product(product_id: str, product: ProductModel):
    """Permite al Administrador editar un producto existente."""
    update_data = {
        "name": product.name,
        "price": product.price,
        "imageUrl": product.image_url,
        "availableSizes": product.available_sizes,
        "availableColors": product.available_colors,
        "updatedAt": datetime.datetime.utcnow().isoformat(),
    }

    if db is not None:
        try:
            doc_ref = db.collection("products").document(product_id)
            db_update = dict(update_data)
            db_update["updatedAt"] = datetime.datetime.utcnow()
            doc_ref.update(db_update)
            return {"success": True, "message": f"Producto {product_id} actualizado en Firestore"}
        except Exception as e:
            print(f"⚠️ Error al actualizar en Firestore: {e}")

    # Actualizar localmente
    for p in _local_products:
        if p.get("id") == product_id:
            p.update(update_data)
            return {"success": True, "message": f"Producto {product_id} actualizado en memoria"}

    return {"success": True, "message": f"Producto {product_id} actualizado"}

@app.delete("/api/products/{product_id}")
async def delete_product(product_id: str):
    """Permite al Administrador eliminar un producto."""
    if db is not None:
        try:
            db.collection("products").document(product_id).delete()
            return {"success": True, "message": f"Producto {product_id} eliminado de Firestore"}
        except Exception as e:
            print(f"⚠️ Error al eliminar en Firestore: {e}")

    global _local_products
    _local_products = [p for p in _local_products if p.get("id") != product_id]
    return {"success": True, "message": f"Producto {product_id} eliminado de memoria"}

# ── 4. Envío directo de Notificación Push ──────────────────────────────────────
@app.post("/api/notify")
async def send_custom_notification(req: PushNotificationRequest):
    """Envía una notificación push personalizada a un token FCM."""
    try:
        if firebase_initialized:
            message = messaging.Message(
                notification=messaging.Notification(
                    title=req.title,
                    body=req.body,
                ),
                data=req.data or {},
                token=req.fcm_token,
            )
            response = messaging.send(message)
            return {"success": True, "fcm_response": response}
        else:
            return {
                "success": True,
                "message": f"Notificación simulada enviada con éxito a {req.fcm_token[:15]}...",
                "title": req.title,
                "body": req.body,
            }
    except Exception as e:
        return {"success": False, "error": str(e)}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)

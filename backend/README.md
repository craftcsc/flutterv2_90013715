# Backend en Python — E-Commerce & Firebase Integration

Este backend en Python complementa la aplicación Flutter para procesar ventas, gestionar productos y enviar **Notificaciones Push** mediante **Firebase Admin SDK** y **Firebase Cloud Functions**.

---

## 🛠️ Requisitos Previos

- Python 3.10 o superior (instalado en tu sistema).
- Proyecto Firebase activo (`flutterv2-app`).

---

## 🚀 Inicio Rápido (FastAPI)

1. **Crear y activar un entorno virtual**:
   ```bash
   cd backend
   python3 -m venv venv
   source venv/bin/activate
   ```

2. **Instalar dependencias**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Ejecutar el servidor local**:
   ```bash
   python3 main.py
   # O con uvicorn directamente:
   uvicorn main:app --reload --host 0.0.0.0 --port 8000
   ```

4. **Documentación Interactiva Swagger**:
   - Abre tu navegador en: [http://localhost:8000/docs](http://localhost:8000/docs)
   - Podrás probar en vivo los endpoints de ventas, productos y push notifications.

---

## 📡 Endpoints Principales

| Método | Endpoint | Descripción |
| :--- | :--- | :--- |
| `POST` | `/api/sales/process-and-notify` | Registra la venta en Firestore y dispara la push notification FCM al comprador. |
| `GET` | `/api/sales` | Consulta todas las ventas registradas para el Administrador. |
| `GET` | `/api/products` | Obtiene el catálogo de productos de Firestore. |
| `POST` | `/api/products` | Agrega un nuevo producto (Admin). |
| `PUT` | `/api/products/{id}` | Modifica un producto existente (Admin). |
| `DELETE`| `/api/products/{id}` | Elimina un producto del catálogo (Admin). |
| `POST` | `/api/notify` | Prueba el envío directo de push notifications a cualquier FCM Token. |

---

## ⚡ Firebase Cloud Functions en Python (`firebase_functions_entry.py`)

Si deseas desplegar directamente a Firebase Functions en la nube:
```bash
firebase deploy --only functions
```
El archivo `firebase_functions_entry.py` incluye el trigger reactivo `on_document_created("sales/{saleId}")` que detecta cualquier venta guardada y despacha la push notification de forma 100% serverless.

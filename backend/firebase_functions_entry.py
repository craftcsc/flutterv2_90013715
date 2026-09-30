"""
Firebase Cloud Function (Python 2nd Gen)
---------------------------------------
Función Cloud de Firebase escrita en Python para activarse ante eventos
de creación de venta en Firestore o invocación HTTP, y enviar la notificación
push mediante Firebase Admin Messaging.

Despliegue con Firebase CLI:
$ firebase deploy --only functions
"""

from firebase_functions import firestore_fn, https_fn
from firebase_admin import initialize_app, firestore, messaging

# Inicializar Firebase Admin SDK en el entorno de Cloud Functions
initialize_app()

@firestore_fn.on_document_created(document="sales/{saleId}")
def notify_sale_on_firestore_creation(event: firestore_fn.Event[firestore_fn.DocumentSnapshot]) -> None:
    """
    Trigger automático de Cloud Firestore:
    Cada vez que se crea un documento en 'sales/{saleId}', esta función
    se ejecuta automáticamente, extrae el token FCM del usuario o de la venta,
    y envía la Push Notification al cliente.
    """
    if event.data is None:
        print("No se recibieron datos en el evento.")
        return

    sale_data = event.data.to_dict()
    if not sale_data:
        print("Documento de venta vacío.")
        return

    user_id = sale_data.get("userId")
    total_amount = sale_data.get("totalAmount", 0.0)
    user_email = sale_data.get("userEmail", "Cliente")
    fcm_token = sale_data.get("fcmToken")

    db = firestore.client()

    # Si la venta no trae el token directamente, buscarlo en users/{userId}
    if not fcm_token and user_id:
        user_doc = db.collection("users").document(user_id).get()
        if user_doc.exists:
            fcm_token = user_doc.to_dict().get("fcmToken")

    if not fcm_token:
        print(f"⚠️ No se encontró fcmToken para el usuario {user_id}. Notificación omitida.")
        return

    try:
        # Construir y despachar notificación push
        message = messaging.Message(
            notification=messaging.Notification(
                title="🛍️ ¡Confirmación de Compra!",
                body=f"Hola {user_email}, tu orden de compra por ${total_amount:.2f} ha sido procesada con éxito.",
            ),
            data={
                "saleId": event.params.get("saleId", ""),
                "total": str(total_amount),
            },
            token=fcm_token,
        )

        response = messaging.send(message)
        print(f"✅ Push Notification enviada exitosamente desde Cloud Function: {response}")
    except Exception as e:
        print(f"❌ Error al enviar push notification desde Cloud Function: {e}")


@https_fn.on_request()
def process_purchase_http(req: https_fn.Request) -> https_fn.Response:
    """
    Función HTTP Invocable (REST) en Firebase Cloud Functions:
    Permite enviar la notificación directamente vía petición POST.
    """
    if req.method != "POST":
        return https_fn.Response("Método no permitido. Utilizar POST.", status=405)

    data = req.get_json(silent=True) or {}
    fcm_token = data.get("fcmToken")
    total = data.get("total", "0.00")

    if not fcm_token:
        return https_fn.Response("Falta 'fcmToken' en el cuerpo JSON.", status=400)

    try:
        message = messaging.Message(
            notification=messaging.Notification(
                title="🛍️ Compra Exitosa (Firebase Function)",
                body=f"Tu compra por ${total} fue completada.",
            ),
            token=fcm_token,
        )
        resp = messaging.send(message)
        return https_fn.Response(f"Notificación enviada: {resp}", status=200)
    except Exception as e:
        return https_fn.Response(f"Error: {e}", status=500)

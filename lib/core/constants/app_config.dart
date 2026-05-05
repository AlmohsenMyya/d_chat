import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get projectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? "d-chat-84fd0";
  
  static Map<String, dynamic> get fcmServiceAccount => {
    "type": "service_account",
    "project_id": projectId,
    "private_key_id": dotenv.env['FCM_PRIVATE_KEY_ID'] ?? "",
    "private_key": (dotenv.env['FCM_PRIVATE_KEY'] ?? "").replaceAll(r'\n', '\n'),
    "client_email": dotenv.env['FCM_CLIENT_EMAIL'] ?? "",
    "client_id": dotenv.env['FCM_CLIENT_ID'] ?? "",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/${dotenv.env['FCM_CLIENT_EMAIL']}",
    "universe_domain": "googleapis.com"
  };

  static String get cloudinaryUrl => dotenv.env['CLOUDINARY_URL'] ?? "";
  static String get cloudinaryUploadPreset => dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? "unsigned_preset";
}

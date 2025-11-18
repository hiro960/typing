import admin from "firebase-admin";

let firebaseApp: admin.app.App | null = null;
let firebaseInitAttempted = false;

function getFirebaseConfig() {
  const projectId = process.env.FIREBASE_PROJECT_ID;
  const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
  const privateKey = process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, "\n");

  if (!projectId || !clientEmail || !privateKey) {
    return null;
  }

  return {
    projectId,
    clientEmail,
    privateKey,
  };
}

function ensureFirebaseApp(): admin.app.App | null {
  if (firebaseApp) {
    return firebaseApp;
  }

  const config = getFirebaseConfig();
  if (!config) {
    if (!firebaseInitAttempted) {
      console.warn(
        "[push] Firebase credentials are not configured. Push notifications are disabled."
      );
      firebaseInitAttempted = true;
    }
    return null;
  }

  firebaseInitAttempted = true;
  try {
    firebaseApp = admin.initializeApp({
      credential: admin.credential.cert({
        projectId: config.projectId,
        clientEmail: config.clientEmail,
        privateKey: config.privateKey,
      }),
    });
    console.info("[push] Firebase Admin initialized");
  } catch (error) {
    console.error("[push] Failed to initialize Firebase Admin SDK", error);
    firebaseApp = null;
  }

  return firebaseApp;
}

export function isPushEnabled() {
  return Boolean(getFirebaseConfig());
}

export async function sendPushNotification(
  message: admin.messaging.Message
): Promise<boolean> {
  const app = ensureFirebaseApp();
  if (!app) {
    return false;
  }

  try {
    await app.messaging().send(message);
    return true;
  } catch (error) {
    console.error("[push] Failed to send push notification", error);
    return false;
  }
}

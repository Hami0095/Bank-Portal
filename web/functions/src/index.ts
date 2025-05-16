import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { MongoClient } from "mongodb";

admin.initializeApp();
const uri = "mongodb+srv://abdman0095:TaMShId6GDbbVshL@cluster0.ojbm5cy.mongodb.net/";

export const testConnection = functions.https.onRequest(async (req, res) => {
  const client = new MongoClient(uri);
  try {
    await client.connect();
    res.status(200).send("Connected to MongoDB!");
  } catch (err) {
    res.status(500).send("Connection failed: " + err);
  } finally {
    await client.close();
  }
});
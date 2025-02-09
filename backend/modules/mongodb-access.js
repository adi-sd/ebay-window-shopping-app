const { MongoClient, ServerApiVersion } = require("mongodb");
const config = require("config");
const LOGGER = require("./logger");

const { MONGODB_USERNAME, MONGODB_PASSWORD, MONGODB_NAME, MONGODB_COLLECTION } = config;

class MongoDB {
    constructor() {
        LOGGER.info("Mongo DB Constructor...");
        this.client = null;
        this.db = null;
    }

    async connect() {
        LOGGER.info("Mongo DB Connection...");
        if (this.client) {
            LOGGER.info("MongoDB already connected!");
            return;
        } else {
            try {
                const mongodbURI = `mongodb+srv://${MONGODB_USERNAME}:${MONGODB_PASSWORD}@cluster0.jdpk4vh.mongodb.net/?retryWrites=true&w=majority`;
                this.client = new MongoClient(mongodbURI);
                await this.client.connect();
                this.db = this.client.db(MONGODB_NAME);
                this.db.command({ ping: 1 });
                LOGGER.info("MongoDB Connected successfully!");
                return this.client;
            } catch (err) {
                LOGGER.error("MongoDB connection error: ", err);
                return;
            }
        }
    }

    async close() {
        if (this.client) {
            await this.client.close();
            this.client = null;
            LOGGER.info("MongoDB connection closed.");
        }
    }

    // Method to get all documents from a collection
    async getAllDocuments() {
        return this.db.collection(MONGODB_COLLECTION).find({}).toArray();
    }

    // Method to find a single item by itemId
    async findItemById(itemId) {
        return this.db.collection(MONGODB_COLLECTION).findOne({ itemId: itemId });
    }

    // Method to add a single item
    async addItem(item) {
        return this.db.collection(MONGODB_COLLECTION).insertOne(item);
    }

    // Method to delete a single item by itemId
    async deleteItemById(itemId) {
        return this.db.collection(MONGODB_COLLECTION).deleteOne({ itemId: itemId });
    }
}

module.exports = new MongoDB();

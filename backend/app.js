"use strict";

const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const app = express();
const externalApis = require("./modules/external-api-calls");
const utils = require("./modules/utils");
const mongodb = require("./modules/mongodb-access");
const LOGGER = require("./modules/logger");

app.use(cors());
app.use(bodyParser.json());

app.use((req, res, next) => {
    LOGGER.info(`Incoming request on ${req.method} ${req.path}`);
    next();
});

app.use((err, req, res, next) => {
    LOGGER.error(`An error occurred: ${err.message}`);
});

app.get("/", (req, res) => {
    res.send("CSCI-571 HW03 Server is online!");
});

// Ebay APIs
app.get("/GetSingleItem", async (req, res) => {
    try {
        const itemId = req.query.item_id;
        const response = await externalApis.ebayGetSingleItem(itemId);
        res.status(200).json(response.data);
    } catch (e) {
        LOGGER.error(e);
        const errorObject = { error: "GetSingleItem API call failed!", message: e.message };
        res.status(500).json(errorObject);
    }
});

app.get("/FindingService", async (req, res) => {
    try {
        const filterObject = JSON.parse(req.query.filter_object_json);
        const response = await externalApis.ebayFindingService(filterObject);
        //LOGGER.info(JSON.stringify(response.data));
        res.status(200).json(utils.extractFindingServiceAPIResult(response.data));
        // res.status(200).json(response.data);
    } catch (e) {
        LOGGER.error(e);
        const errorObject = { error: "FindingService API call failed!", message: e.message };
        res.status(500).json(errorObject);
    }
});

app.get("/GetRelatedItems", async (req, res) => {
    try {
        const itemId = req.query.item_id;
        const response = await externalApis.ebayMerchandisingService(itemId);
        res.status(200).json(response.data);
    } catch (e) {
        LOGGER.error(e);
        const errorObject = { error: "GetSingleItem API call failed!", message: e.message };
        res.status(500).json(errorObject);
    }
});

// Google API
app.get("/CustomImageSearch", async (req, res) => {
    try {
        const query = req.query.search_query;
        const response = await externalApis.googleCustomImageSearch(query);
        res.status(200).json(utils.customSearchResults(response.data));
    } catch (e) {
        LOGGER.error(e);
        const errorObject = { error: "CustomImageSearch API call failed!", message: e.message };
        res.status(500).json(errorObject);
    }
});

// Geonames Postal Code
app.get("/GetPostalCodes", async (req, res) => {
    try {
        const postalCode = req.query.postal_code;
        const response = await externalApis.geonamesPostalCodeSearch(postalCode);
        res.status(200).json(utils.postalCodesResults(response.data));
    } catch (e) {
        LOGGER.error(e);
        const errorObject = { error: "GetPostalCodes API call failed!", message: e.message };
        res.status(500).json(errorObject);
    }
});

// Mongo DB Calls
app.get("/wishlist/getAllItems", async (req, res) => {
    try {
        const items = await mongodb.getAllDocuments();
        res.status(200).json({ items: items });
    } catch (error) {
        res.status(500).json({ message: "Error retrieving items", error: error.message });
    }
});

app.post("/wishlist/addSingleItem", async (req, res) => {
    try {
        const itemData = req.body;
        const newItem = await mongodb.addItem(itemData);
        //LOGGER.info(JSON.stringify(newItem));
        res.status(201).json(newItem);
    } catch (error) {
        res.status(500).json({ message: "Error adding item", error: error.message });
    }
});

app.delete("/wishlist/deleteSingleItem", async (req, res) => {
    try {
        const itemId = req.query.item_id;
        const result = await mongodb.deleteItemById(itemId);
        if (result.deletedCount === 0) {
            return res.status(404).json({ message: "Item not found" });
        }
        res.status(200).json({ message: "Item deleted successfully" });
    } catch (error) {
        res.status(500).json({ message: "Error deleting item", error: error.message });
    }
});

app.get("/wishlist/getSingleItem", async (req, res) => {
    try {
        const itemId = req.query.item_id;
        const result = await mongodb.findItemById(itemId);
        if (!result) {
            return res.status(404).json({ message: "Item not found" });
        }
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ message: "Error deleting item", error: error.message });
    }
});

app.listen(8080, () => {
    LOGGER.info("Server is running on port 8080");
    mongodb.connect();
});

process.on("SIGINT", async () => {
    await mongodb.close();
    process.exit(0);
});

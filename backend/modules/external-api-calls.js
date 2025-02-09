const axios = require("axios");
const config = require("config");
const LOGGER = require("./logger");
const utils = require("./utils");
const ebayAuth = require("./ebay-auth");

const {
    EBAY_FINDING_SERVICE_URL,
    EBAY_GET_SINGLE_ITEM_URL,
    EBAY_MERCHANDISING_URL,
    EBAY_AUTH_TOKEN_HEADER,
    GOOGLE_CUSTOM_SEARCH_URL,
    GEONAMES_API_URL,
} = config;

async function googleCustomImageSearch(query) {
    LOGGER.info("Performing Google Custom Image Search for - " + query);
    const data = {
        q: query,
    };
    try {
        const response = await axios.get(GOOGLE_CUSTOM_SEARCH_URL, { params: data });
        return response;
    } catch (e) {
        LOGGER.error("Error while executing Google Custom Search Call - " + e);
        throw e;
    }
}

async function geonamesPostalCodeSearch(postalCode) {
    LOGGER.info("Performing Geonames Postal Code Search - " + postalCode);
    const data = {
        postalcode_startsWith: postalCode,
    };
    try {
        const response = await axios.get(GEONAMES_API_URL, { params: data });
        return response;
    } catch (e) {
        LOGGER.error("Error while executing Geonames Postal Code Search Call - " + e);
        throw e;
    }
}

async function ebayGetSingleItem(itemId) {
    LOGGER.info("Performing eBay get single item for item ID - " + itemId);
    try {
        const authToken = await ebayAuth.getApplicationToken();
        const response = await axios.get(EBAY_GET_SINGLE_ITEM_URL, {
            headers: { [EBAY_AUTH_TOKEN_HEADER]: authToken },
            params: { ItemID: itemId },
        });
        return response;
    } catch (e) {
        LOGGER.error("Error while executing eBay Get Single Item Call - " + e);
        throw e;
    }
}

async function ebayFindingService(filterObject) {
    LOGGER.info("Performing eBay Findig Service for filter - " + JSON.stringify(filterObject));
    try {
        const flattenedFilters = utils.flattenFilterObject(filterObject);
        LOGGER.info("Flattened Filter - " + JSON.stringify(flattenedFilters));
        const response = await axios.get(EBAY_FINDING_SERVICE_URL, { params: flattenedFilters });
        return response;
    } catch (e) {
        LOGGER.error("Error while executing eBay Finding Service Call - " + e);
        throw e;
    }
}

async function ebayMerchandisingService(itemId) {
    LOGGER.info("Performing eBay Merchandising Service for item ID - " + itemId);
    try {
        const response = await axios.get(EBAY_MERCHANDISING_URL, { params: { itemId: itemId } });
        return response;
    } catch (e) {
        LOGGER.error("Error while executing eBay Merchandising Service Call - " + e);
        throw e;
    }
}

module.exports = {
    googleCustomImageSearch,
    ebayGetSingleItem,
    ebayFindingService,
    ebayMerchandisingService,
    geonamesPostalCodeSearch,
};

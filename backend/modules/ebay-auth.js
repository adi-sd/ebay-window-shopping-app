const axios = require("axios");
const config = require("config");
const LOGGER = require("./logger");

const { EBAY_CLIENT_ID, EBAY_CLIENT_SECRET, EBAY_OAUTH_URL, EBAY_OAUTH_SCOPE } = config;

async function getApplicationToken() {
    LOGGER.info("Getting eBay OAuth Token...");

    const authString = `${EBAY_CLIENT_ID}:${EBAY_CLIENT_SECRET}`;
    const base64String = Buffer.from(authString, "utf-8").toString("base64");

    const headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        Authorization: `Basic ${base64String}`,
    };

    const data = {
        grant_type: "client_credentials",
        scope: EBAY_OAUTH_SCOPE,
    };

    try {
        const response = await axios.post(EBAY_OAUTH_URL, data, { headers });
        LOGGER.info("Success for Getting Ebau Auth Token!");
        return response.data.access_token;
    } catch (e) {
        LOGGER.error("Error while executing get Ebay OAuth Token Call - " + e);
        throw e;
    }
}

module.exports = {
    getApplicationToken,
};

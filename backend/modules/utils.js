function flattenFilterObject(filterObject, parentKey = "", sep = ".") {
    const items = [];

    for (const [key, value] of Object.entries(filterObject)) {
        const newKey = parentKey ? `${parentKey}${sep}${key}` : key;

        if (value && typeof value === "object" && !Array.isArray(value)) {
            items.push(...Object.entries(flattenFilterObject(value, newKey, sep)));
        } else if (Array.isArray(value)) {
            value.forEach((item, idx) => {
                const arrayKey = `${newKey}(${idx})`;
                if (typeof item === "object" && !Array.isArray(item)) {
                    items.push(...Object.entries(flattenFilterObject(item, arrayKey, sep)));
                } else {
                    items.push([arrayKey, item]);
                }
            });
        } else if (typeof value === "boolean") {
            items.push([newKey, value ? "true" : "false"]);
        } else {
            items.push([newKey, value]);
        }
    }

    return Object.fromEntries(items);
}

function customSearchResults(jsonInput) {
    let links = [];
    if (jsonInput.items && Array.isArray(jsonInput.items) && jsonInput.items.length > 0) {
        links = jsonInput.items.map((item) => item.link);
    }
    return { customSearchResults: links };
}

function postalCodesResults(jsonInput) {
    let postalCodes = [];
    if (jsonInput.postalCodes && Array.isArray(jsonInput.postalCodes) && jsonInput.postalCodes.length > 0) {
        postalCodes = jsonInput.postalCodes.map((item) => item.postalCode);
    }
    return { postalCodesResults: postalCodes };
}

function extractFindingServiceAPIResult(apiResultObject) {
    let findItemsAdvancedObject = apiResultObject.findItemsAdvancedResponse[0];
    let resultItems = {
        items: [],
    };
    if (findItemsAdvancedObject && findItemsAdvancedObject.ack[0] == "Success") {
        let searchResultObject = findItemsAdvancedObject.searchResult[0];
        if (searchResultObject) {
            if (searchResultObject["@count"] > 0) {
                for (const item of searchResultObject.item) {
                    let shippingPrice = "N/A";
                    if (parseFloat(item.shippingInfo[0].shippingServiceCost[0]["__value__"]) === 0.0) {
                        shippingPrice = "Free Shipping";
                    } else {
                        shippingPrice = item.shippingInfo[0].shippingServiceCost[0]["__value__"];
                    }

                    let resultItem = {
                        id: item.itemId ? item.itemId[0] : "itemId",
                        itemId: item.itemId ? item.itemId[0] : "itemId",
                        itemTitle: item.title ? item.title[0] : "itemTitle",
                        itemImage: item.galleryURL ? item.galleryURL[0] : "itemImage",
                        itemZipCode: item.postalCode ? item.postalCode[0] : "itemZipCode",
                        itemPrice: item.sellingStatus ? item.sellingStatus[0].currentPrice[0]["__value__"] : "NA",
                        itemShipping: shippingPrice ? shippingPrice : "NA",
                        itemCondition: item.condition ? item.condition[0].conditionId[0] : "NA",
                        itemUrlonEbay: item.viewItemURL ? item.viewItemURL[0] : "NA",
                    };
                    resultItems.items.push(resultItem);
                }
                return resultItems;
            } else {
                return resultItems;
            }
        }
    } else {
        return resultItems;
    }
}

module.exports = {
    flattenFilterObject,
    customSearchResults,
    postalCodesResults,
    extractFindingServiceAPIResult,
};

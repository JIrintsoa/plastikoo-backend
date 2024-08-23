const { createClient } = require("redis");
import cache from "../config/cache";

let redisClient;

async function initializeRedisClient() {
    try {
        redisClient = createClient();
        await redisClient.connect();
        console.log("Redis Connected Successfully");
    } catch (e) {
        console.error(`Redis connection failed with error:`);
        console.error(e);
    }
}

function cacheMiddleware(
    options = {
      EX: 10800, // 3h
    },
    ) {
    return async (req, res, next) => {
        if (redisClient?.isOpen) {
            //if cached data is found retrieve it
            const cacheKey = cache.cacheKey.contact
            const cachedValue = await redisClient.get(cacheKey);
            if (cachedValue) {
                return res.json(JSON.parse(cachedValue));
            }
        }
    };
}
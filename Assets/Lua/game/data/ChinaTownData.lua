local data = {}
--格子大小
data.gridSize = 64
--地位置信息
data.area = {
    [1] = {
        x = -383.5,
        y = 319,
        startIndex = 1,
        map = {
            {0,1,1,0},
            {0,1,1,1},
            {1,1,1,1},
            {1,1,1,0},
            {1,1,1,0},
        }
    },
    [2] = {
        x = -63.5,
        y = 319,
        startIndex = 16,
        map = {
            {1,1,1},
            {1,1,1},
            {1,1,0},
            {1,1,0},
            {1,1,0}
        }
    },
    [3] = {
        x = 192.5,
        y = 319,
        startIndex = 28,
        map = {
            {1,1,1,0},
            {1,1,1,0},
            {1,1,1,0},
            {0,1,1,1},
            {0,1,1,1}
        }
    },
    [4] = {
        x = -383.5,
        y = -65,
        startIndex = 43,
        map = {
            {1,1,1,1},
            {1,1,1,1},
            {1,1,1,1},
            {0,0,1,1},
            {0,0,1,1}
        }
    },
    [5] = {
        x = -63.5,
        y = -65,
        startIndex = 59,
        map = {
            {1,1,0},
            {1,1,0},
            {1,1,1},
            {1,1,1},
            {0,1,1}
        }
    },
    [6] = {
        x = 192.5,
        y = -65,
        startIndex = 71,
        map = {
            {1,1,1,1},
            {1,1,1,1},
            {1,1,1,1},
            {1,1,1,0}
        }
    }

}
--店铺点数信息
data.shop = {
    [1] = 3,
    [2] = 3,
    [3] = 3,
    [4] = 4,
    [5] = 4,
    [6] = 4,
    [7] = 5,
    [8] = 5,
    [9] = 5,
    [10] = 6,
    [11] = 6,
    [12] = 6,
}

data.cards = {
    [3] = {
        7,6,6,6,6,6
    },
    [4] = {
        6,5,5,5,5,5
    },
    [5] = {
        5,5,5,4,4,4
    }
}

data.shopDes = {
    [1] = {
        name = "烧鸡店",
        des = "烧鸡，诚招加盟代理。3连获得最高收益5W。"
    },
    [2] = {
        name = "火腿店",
        des = "火腿，诚招加盟代理。3连获得最高收益5W。"
    },
    [3] = {
        name = "牛排店",
        des = "牛排，诚招加盟代理。3连获得最高收益5W。"
    },
    [4] = {
        name = "水产店",
        des = "水产，诚招加盟代理。4连获得最高收益8W。"
    },
    [5] = {
        name = "家具店",
        des = "家具，诚招加盟代理。4连获得最高收益8W。"
    },
    [6] = {
        name = "建材店",
        des = "建材，诚招加盟代理。4连获得最高收益8W。"
    },
    [7] = {
        name = "铁匠铺",
        des = "铁匠，诚招加盟代理。5连获得最高收益11W。"
    },
    [8] = {
        name = "杂粮铺",
        des = "杂粮，诚招加盟代理。5连获得最高收益11W。"
    },
    [9] = {
        name = "药店",
        des = "草药，诚招加盟代理。5连获得最高收益11W。"
    },
    [10] = {
        name = "灯具店",
        des = "灯具，诚招加盟代理。6连获得最高收益14W。"
    },
    [11] = {
        name = "酒吧",
        des = "酒吧，诚招加盟代理。6连获得最高收益14W。"
    },
    [12] = {
        name = "古玩店",
        des = "古玩,诚招加盟代理。6连获得最高收益14W。"
    }
}

return data 
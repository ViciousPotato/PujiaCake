db.expressfees.remove();
var provinces = [
  "北京市", "天津市", "上海市", "重庆市", "河北省", 
  "山西省", "台湾省", "辽宁省", "吉林省", "黑龙江省",
  "江苏省", "浙江省", "安徽省", "福建省", "江西省", 
  "山东省", "河南省", "湖北省", "湖南省", "广东省", 
  "甘肃省", "四川省", "贵州省", "海南省", "云南省", 
  "青海省", "陕西省", "广西壮族自治区", "西藏自治区", 
  "宁夏回族自治区", "其它"
];

var provinceFees = [
  {
    province: "上海市",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        4.0,
        basicWeight:     1000,
        extraFeeUnit:    1.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "江苏省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        4.0,
        basicWeight:     1000,
        extraFeeUnit:    1.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "浙江省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        4.0,
        basicWeight:     1000,
        extraFeeUnit:    1.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "安徽省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        4.0,
        basicWeight:     1000,
        extraFeeUnit:    1.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "新疆维吾尔自治区",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        13.0,
        basicWeight:     1000,
        extraFeeUnit:    9.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "西藏自治区",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        13.0,
        basicWeight:     1000,
        extraFeeUnit:    9.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "青海省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        13.0,
        basicWeight:     1000,
        extraFeeUnit:    9.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "甘肃省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        13.0,
        basicWeight:     1000,
        extraFeeUnit:    9.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "云南省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        13.0,
        basicWeight:     1000,
        extraFeeUnit:    9.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "贵州省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        13.0,
        basicWeight:     1000,
        extraFeeUnit:    9.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "北京市",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        6.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "广东省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        6.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "天津市",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        6.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "河北省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        6.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "山东省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        6.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "河南省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        6.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "重庆市",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        7.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "山西省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        7.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "台湾省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        100.0,
        basicWeight:     1000,
        extraFeeUnit:    100.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "辽宁省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        7.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "吉林省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        7.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "黑龙江省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        7.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "福建省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        7.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "江西省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        7.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "湖北省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        7.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "湖南省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        7.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "四川省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        7.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "海南省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        7.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "陕西省",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        7.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "广西壮族自治区",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        7.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "宁夏回族自治区",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        7.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  },
  {
    province: "其它",
    sfFee: {
        basicFee:        5.0,
        basicWeight:     500,
        extraFeeUnit:    2.0,
        extraWeightUnit: 500
    },
    othersFee: {
        basicFee:        7.0,
        basicWeight:     1000,
        extraFeeUnit:    5.0,
        extraWeightUnit: 1000        
    }
  }
];

provinceFees.forEach(function(provinceFee) {
    db.expressfees.insert(provinceFee);
});
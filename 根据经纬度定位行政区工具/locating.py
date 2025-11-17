# 导入第三方库
import requests
import pandas as pd
import time

# 高德地图API接口的Key值
AK = "ed0d7b6b0572413c0ab21e1a57caa68c"  # 此处需要更换为自己的，我的随时会失效，需要自己注册申请得到一个key值，每天都有免费调用次数，足够用。

# 读取需要匹配的经纬度数据
data = pd.read_excel("江苏.xlsx")


def fun(x):
    res = requests.get(x)
    time.sleep(1)
    val = res.json()

    if val.get('status') == '1' and val.get('regeocode'): # 检查status 和 regeocode
        address_component = val['regeocode'].get('addressComponent', {})
        province = address_component.get('province', '未知')
        city = address_component.get('city', '未知')
        district = address_component.get('district', '未知')
        return [province, city, district]
    else:
        # 处理 API 请求失败或缺少 regeocode 的情况，例如记录错误信息或返回默认值
        print(f"API请求失败或无结果: {x}, 返回数据: {val}")  # 打印错误信息以便调试
        return ["未知", "未知", "未知"]
# 此处是为了生成每一个位置信息在调用地图API接口时使用的url地址，因为每个位置信息的经度和纬度信息不一致。因此，每一个位置信息对应一个url，url的格式固定，不要修改，只需要更改对应的经度和纬度值即可，此处可直接使用，无需修改。
data["经纬度1"] = data["经度"].map(lambda x: [x])
data["经纬度2"] = data["纬度"].map(lambda x: [x])
data["经纬度"] = data["经纬度1"] + data["经纬度2"]
data["url"] = data["经纬度"].map(lambda x: "https://restapi.amap.com/v3/geocode/regeo?output=json&location={0},{1}&key={2}&extensions=all".format(str(x[0]), str(x[1]), AK))

data["省市县"] = data["url"].map(lambda x: fun(x))
data.to_excel("信息查询结果.xlsx", index=False)

data = pd.read_excel("信息查询结果.xlsx")
data["省份"] = data["省市县"].map(lambda x: x.split(",")[0][2:-1])  # 通过字符串分割后再取出所需要的信息
data["市区"] = data["省市县"].map(lambda x: x.split(",")[1][2:-1])  # 通过字符串分割后再取出所需要的信息
data["县域"] = data["省市县"].map(lambda x: x.split(",")[2][2:-2])  # 通过字符串分割后再取出所需要的信息
data.to_excel("经纬度匹配县域_clean.xlsx")
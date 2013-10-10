# We · Cloud云技术小组

We · Cloud云技术小组（以下简称本小组）是大连东软信息学院由学生组建的技术小组，隶属于网络中心，主要职责是为校园网提供优质的网络服务。

## 目录结构

当前在根目录下，有三个子目录`bashes`、`conf`和`sites`，用途如下：

* `bashes`：一些本小组正在使用的脚本（未完全同步）
* `conf`：一些本小组正在使用的Nginx配置文件（未完全同步）
* `sites`：We当前网站源码

## 使用说明

### 运行环境

Python 2.x (2.6.5+)
Django 1.5+

### 配置说明

下载`sites`目录中的全部文件，在`we`目录中创建`settings.py`配置文件，启动`Django`服务器即可。
*注意：我们在`we`目录中存放了一份本小组正在使用的配置文件样本`settings.py.sample`，并将敏感信息使用`WE_CLOUD`进行了替换。*

- - -

感谢大连东软信息学院网络中心提供本小组所有硬件及网络资源。
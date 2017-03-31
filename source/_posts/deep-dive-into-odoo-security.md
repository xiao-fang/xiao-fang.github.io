---
title: Deep Dive Into Odoo Security
tags: odoo; others
---

#### Deep Dive Into Odoo Security

	# Deep Dive Into Odoo Security
	© Edward | xiao.fang@outlook.com

[TOC]

***
#### 演示数据准备

##### Demo Users ( `res_users` )

> - `demo_customer`
> - `demo_sales`
> - `demo_manager`

* 创建 `res_users`, 如果不显示指定 `partner_id`,  则系统默认创建一条`res_partner`记录. 

``` python
class res_users(osv.osv):
    """ User class. A res.users record models an OpenERP user and is different
        from an employee.

        res.users class now inherits from res.partner. The partner model is
        used to store the data related to the partner: lang, name, address,
        avatar, ... The user model is now dedicated to technical data.
    """

    _inherits = {
        'res.partner': 'partner_id',
    }
    _name = "res.users"
```

##### Demo Groups ( `res_groups` )

> - `demo.group_ciic_customer`
> - `demo.group_ciic_sales`
> - `demo.group_ciic_manager`

##### Demo Models & Views

> - `ciic_demo_invoice`
> - `ciic_demo_lead`
> - `ciic_demo_quotation`
> - `ciic_demo_shared`

##### Menu Items ( `ir_ui_menu, ir_ui_menu_group_rel` )
> `MenuItem` 可以通过 `attribute 'groups'`配置访问权限, 当且仅当`MenuItem`指向的`Action`是可以访问的情况下, 该`MenuItem`才显示. (`跟是否有记录/或者能否新增记录没有半毛钱关系`) 

|L0 Menu | L1 Menu |  L2 Menu  | Full Access Users  | Full Access Models |
| :---  | :--- | :--- | :--- | :--- |
| `Demo Module` 	|    | |   |
|  	|   `Demo Entry` | |   |
|  	|    |`Customer Entry` | `demo.group_ciic_customer`|`ciic_demo_lead` |
|  |    |  `Sales Entry`| `demo.group_ciic_sales`| `ciic_demo_quotation` |
|  |    |  `Manager Entry`| `demo.group_ciic_manager` | `ciic_demo_invoice` |
|  |    |  `Shared Entry`| `*` | `*` |

***

#### `odoo` 权限机制

> `odoo`的权限控制 (`Managed By`) 有以下几个因素.
> * 组 `Groups` 
> * 访问控制 `Access Control`
> * 字段访问控制 `Field Access`
> * 记录规则 `Record Rules`
> * 工作流事务规则 `Workflow Transaction Rules`

##### Groups

> `res_users`和`res_groups`的关联关系: `res_groups_users_rel`
> *  一个 `user` 可以属于 任意个 `group`  ( *A user can belongs to any number of groups* )
> * `user` 拥有所在`group`的所有权限 ( *A user has access to all permissions granted to any of its groups* )

##### Access Control List (`ACL`)

> 数据库相关表: `ir_model_access, ir_model, res_groups`
> * `ACL`的目标对象是 `model`, 即`ORM`映射的数据库表.
> * `ACL`可以配置 `create, read, wirte(edit/update), delete(unlink)`权限.
> * `ACL` ***可选*** 配置 `group`, 
>   ○　配置了`group`, 则当前`ACL`适用于`group`所有成员`user`.
>   ○　未配置`group`, 则当前`ACL`适用于所有`user`.
> * `ACL`之间可以累加, 取并集. (`additive`).

配置ACL, `*.csv`
![Access Control](/assets/oddo-security-01.png)

![ACL Config](/assets/oddo-security-02.png)

[Practice]
- 给Sales添加Lead的Read / Write权限, 看读写, 和Menu变化.

##### Field Access

> 数据库相关表: `ir_model_fields, ir_model_fields_group_rel`
> 字段控制的是访问权限, `CRWD`一键开关.
> * 通过 `attribute "groups"` 来控制字段的访问权限, 多个`groups`之间以**逗号**(`,`)分隔.
> * 可以应用到大部分`tags`, 比如,  `</field>, </button>, </groups>,</page>`
> * model / xml  `attribute "groups"` 是等价的, 同时在model / xml 中指定了 `attribute "groups"`, 取 交集 (`subtractive`) 

```xml
<field name="ex1" groups="demo.group_ciic_manager, module.xx_group_xx"/>
```

``` python
ex1 = fields.Char('Ex1', size=64, groups='demo.group_ciic_customer, module.xx_group_xx')
```

[Practice]
* 在Model / XML 上更改 attribute 'groups', 看EX1 / EX2 字段的表现.


##### Record Rules (`RR`)

> `RR` 构成元素:
> - `Model` 
> -  `create, read, wirte(edit/update), delete(unlink)` 分别权限.
> - `domain` 过滤条件, 条件满足, 可以访问, 不满足, 不可以访问.
> - `groups`, 不指定, 则为全局规则(`Global Rules`), 指定则为组规则(`Groups Rules`).

数据库相关表: `ir_rule, rule_group_rel`

> 全局规则(`Global Rules`)之间, 取交集 (`subtractive`), 逻辑与 `AND`.
> 组规则(`Groups Rules`) 之间, 取并集 (`additive`), 逻辑或 `OR`.

> `Example: GLOBAL_RULE_1 AND GLOBAL_RULE_2 AND ( (GROUP_A_RULE_1 OR GROUP_A_RULE_2) OR (GROUP_B_RULE_1 OR GROUP_B_RULE_2) )`

> *Note: This means the first group rule restricts access, but any further group rule expands it, while global rules can only ever restrict access (or have no effect).*


##### `Access Control List` v.s. `Record Rules`

> * `ACL`可以转换成等价的`RR`, `RR`相对于`ACL`多了Domain Filter的条件过滤.
> * `ACL` 的控制对象是*Model*, 即对应的数据库表, `RR`的控制对象是Model对应的*Records*.
> *  [Question] `RR`的`RWCD`没作用?
   

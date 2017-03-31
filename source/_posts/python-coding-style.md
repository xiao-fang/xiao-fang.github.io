---
title: Python Coding Style
tags:
    - python
    - others
---

#### 1.  Python 代码规范

	# Deep Dive Into Odoo Security
	© Edward | xiao.fang@outlook.com

##### 分号( ; )

>不要在行尾加分号, 也不要用分号将两条命令放在同一行.

##### 行长度
> - 每行不超过 ***80*** 个字符
> - 例外:  长的导入模块语句; 注释里的URL

##### 换行 / 行间连接
> - 不要使用反斜杠连接行.
> - Python会将圆括号 ( ), 中括号 [ ], 花括号 { } 中的行隐式的连接起来.

所以, 你可以利用这个特点. 如果需要, 你可以在表达式外围增加一对额外的圆括号.
```python
 if (width == 0 and height == 0 and
     color == 'red' and emphasis == 'strong'):
```
如果一个文本字符串在一行放不下, 可以使用圆括号来实现隐式行连接:
```python
  x = ('This will build a very long long long and long'
         'long long long long long and long long long string')
```
在注释中，如果必要，将长的URL放在一行上.
``` python
# URL单行注释 [Good]
# https://www.python.org/dev/peps/pep-0008/#public-and-internal-interfaces

# URL跨行'\'连接注释 [Bad]
# https://www.python.org/dev/peps/pep-0008/#\
# public-and-internal-interfaces
```
##### 括号
> - 原则: 宁缺勿滥

除非是用于实现行连接, 或者 ( ) 用来表示Tuple, 否则不要在返回语句或条件语句中使用括号.
```python
 Yes: if foo:
             bar()
         while x:
             x = bar()
         if x and y:
             bar()
         if not x:
             bar()

         return foo
         for (x, y) in dict.items(): ...

 No:  if (x):
             bar()
         if not(x):
             bar()
         return (foo)
```
##### 缩进
> 用 ***4个空格*** 来缩进代码

不要: Tab, 或者 Tab和空格混用.

对于行连接的情况, 你应该: 要么垂直对齐换行的元素;  或者使用4空格的悬挂式缩进(这时第一行不应该有参数).
```python
# 垂直对齐开分隔符(opening delimiter)
foo = long_function_name(var_one, var_two,
						 var_three, var_four)

# 4空格悬挂缩进, 首行无参数
foo = long_function_name(
	var_one, var_two, var_three,
	var_four)
```
##### 空行
> 顶级定义之间空两行, 方法定义之间空一行
顶级定义, 如, 类(***class***), 函数 (***function***), 模块引入(***import***) 之间空两行;
方法(***method***)定义, 类定义与第一个方法之间, 都应该空一行.
函数或方法中, 某些地方要是你觉得合适, 就空一行.

#####  空格
> 按照标准的排版规范来使用标点两边的空格

括号内不要有空格.
``` python
Yes: spam(ham[1], {eggs: 2}, [])
```
``` python
No:  spam( ham[ 1 ], { eggs: 2 }, [ ] )
```
不要在逗号, 分号, 冒号前面加空格, 但应该在它们后面加(除了在行尾).
``` python
Yes: if x == 4:
		 print x, y
	 x, y = y, x
```
```python
 No:  if x == 4 :
           print x , y
       x , y = y , x
```
参数列表, 索引或切片的左括号前不应加空格.
```python
Yes: 	spam(1)
No : 	spam (1)

Yes: 	dict['key'] = list[index]
No :  	dict ['key'] = list [index]
```
在二元操作符两边都加上一个空格, 比如赋值(***=***), 比较(***==, <, >, !=, <>, <=, >=, in, not in, is, is not***), 布尔(***and, or, not***).
至于算术操作符两边的空格, 两侧务必要保持一致即可.
```python
Yes: 	x == 1
No:  	x<1
```
当 '***=***' 用于指示关键字参数或默认参数值时, 不要在其两侧使用空格.

``` python
Yes: 	def complex(real, imag=0.0): return magic(r=real, i=imag)
No:  	def complex(real, imag = 0.0): return magic(r = real, i = imag)
```

不要用空格来垂直对齐多行间的标记, 因为这会成为维护的负担(适用于 ***:, #, =*** 等):

```python
Yes:
     foo = 1000  # comment
     long_name = 2  # comment that should not be aligned

     dictionary = {
         "foo": 1,
         "long_name": 2,
         }
```
```python
No:
     foo       = 1000  # comment
     long_name = 2     # comment that should not be aligned

     dictionary = {
         "foo"      : 1,
         "long_name": 2,
         }
```

##### Shebang
> 大部分 ***.py*** 文件不必以#!作为文件的开始. 根据 `PEP-394 <http://www.python.org/dev/peps/pep-0394/>`,  程序的 ***main*** 文件应该以 `#!/usr/bin/python2`或者 `#!/usr/bin/python3`开始.

`#!`先用于帮助内核找到Python解释器, 但是在导入模块时, 将会被忽略. 因此只有被直接执行的文件中才有必要加入`#!`.

##### 注释
> 确保对模块, 函数, 方法和行内注释使用正确的风格

文档字符串 (`Doc Strings`)

- Python有一种独一无二的的注释方式: 使用文档字符串. 文档字符串是包, 模块, 类或函数里的第一个语句. 这些字符串可以通过对象的doc成员被自动提取, 并且被`pydoc`所用

模块 (`Module`)
 - 每个文件应该包含一个许可样板. 根据项目使用的许可(例如, `Apache 2.0, BSD, LGPL, GPL`), 选择合适的样板.

函数 (`Function`) 和方法 (`Method`)
- 一个函数 (下文所指包括 `Function, Method, Generator` ) **必须** 要有文档字符串.  (`外部不可见/非常短小/简单明了`的函数除外)
- Args: 列出每个参数的名字, 并在名字后使用一个冒号和一个空格, 分隔对该参数的描述.如果描述太长超过了单行80字符,使用4空格的悬挂缩进. 描述应该包括所需的类型和含义. 如果一个函数接受*foo(可变长度参数列表)或者`*bar (任意关键字参数)`, 应该详细列出`foo`和`**bar`.

- Returns: (或者 Yields: 用于生成器) 描述返回值的类型和语义. 如果函数返回None, 这一部分可以省略.

- Raises: 列出与接口有关的所有异常.

```python
def fetch_bigtable_rows(big_table, keys, other_silly_variable=None):
    """Fetches rows from a Bigtable.

    Retrieves rows pertaining to the given keys from the Table instance
    represented by big_table....

    Args:
        big_table: An open Bigtable Table instance.
        keys: A sequence of strings representing the key...
        other_silly_variable: Another optional variable, ...

    Returns:
        A dict mapping keys to, .... For example:

        {'Serak': ('Rigel VII', 'Preparer'),
         'Lrrr': ('Omicron Persei 8', 'Emperor')}

        If a key from the keys argument is missing from the dictionary,
        then that row was not found in the table.

    Raises:
        IOError: An error occurred accessing the bigtable.Table object.
    """
    pass
```
类(`Class`)

- 类应该在其定义下有一个用于描述该类的文档字符串. 如果你的类有公共属性(Attributes), 那么文档中应该有一个属性(Attributes)段. 并且应该遵守和函数参数相同的格式.

```python
class SampleClass(object):
    """Summary of class here.

    Longer class information....

    Attributes:
        likes_spam: A boolean indicating if we like SPAM or not.
        eggs: An integer count of the eggs we have laid.
    """

    def __init__(self, likes_spam=False):
        """Inits SampleClass with blah."""
        self.likes_spam = likes_spam
        self.eggs = 0

    def public_method(self):
        """Performs operation blah."""
```
块注释和行注释

对于复杂的操作, 应该在其操作开始前写上若干行注释. 对于不是一目了然的代码, 应在其行尾添加注释.

``` python
# We use a weighted dictionary search to find out where i is in
# the array.  We extrapolate position based on the largest num
# in the array and the array size and then do binary search to
# get the exact number.

if i & (i-1) == 0:        # true if i is a power of 2
```

##### 类
> 如果一个类不继承自其它类, 就显式的从object继承. 嵌套类也一样.

``` python
Yes: class SampleClass(object):
         pass

     class OuterClass(object):

         class InnerClass(object):
             pass

     class ChildClass(ParentClass):
         """Explicitly inherits from another class already."""
```

```python
No: class SampleClass:
        pass

    class OuterClass:

        class InnerClass:
            pass
```
##### 字符串
> `%` 格式化字符串, `+` 拼接字符串

避免在循环中用+和+=操作符来累加字符串. 由于字符串是不可变的, 这样做会创建不必要的临时对象, 并且导致二次方而不是线性的运行时间.
作为替代方案, 你可以将每个子串加入列表, 然后在循环结束后用 `.join` 连接列表. (也可以将每个子串写入一个 `cStringIO.StringIO` 缓存中.)
```python
Yes:	items = ['<table>']
		for last_name, first_name in employee_list:
		    items.append('<tr><td>%s, %s</td></tr>' % (last_name, first_name))
		items.append('</table>')
		employee_table = ''.join(items)

No: 	employee_table = '<table>'
        for last_name, first_name in employee_list:
            employee_table += '<tr><td>%s, %s</td></tr>' % (last_name, first_name)
        employee_table += '</table>'
```

多行字符串使用三重双引号`"""`而非三重单引号`'''`.
文档字符串必须使用三重双引号`"""`.

##### 文件和sockets
> 在文件和sockets结束时, 显式的关闭它.

推荐使用 [`with`语句](http://docs.python.org/reference/compound_stmts.html#the-with-statement) 以管理文件:

``` python
 with open("hello.txt") as hello_file:
     for line in hello_file:
         print line
```
对于不支持使用 `with` 语句的类似文件的对象,使用 `contextlib.closing()` :
``` python
 import contextlib

 with contextlib.closing(urllib.urlopen("http://www.python.org/")) as front_page:
     for line in front_page:
         print line
```

##### TODO注释
> 为临时代码使用TODO注释, 它是一种短期解决方案. 但够好了.

```python
# TODO(fxiao@hpe.com): Use a "*" here for string repetition.
# TODO(Edward) Change this to use relations.
```

##### 导入 ( `import` ) 格式
> 每个导入 (`import`) 应该独占一行

```python
Yes: import os
     import sys

No:  import os, sys
```
导入总应该放在文件顶部, 按顺序分组:
- 标准库导入
- 第三方库导入
- 应用程序指定导入

每种分组中, 应该根据每个模块的完整包路径按字典序排序, 忽略大小写.
``` python
import foo
from foo import bar
from foo.bar import baz
from foo.bar import Quux
from Foob import ar
```
##### 语句
>通常每个语句应该独占一行

```python
Yes:

  if foo: bar(foo)

No:

  if foo: bar(foo)
  else:   baz(foo)

  try:               bar(foo)
  except ValueError: baz(foo)

  try:
      bar(foo)
  except ValueError: baz(foo)
```

##### 访问控制
> 在Python中, 对于琐碎又不太重要的访问函数, 你应该直接使用公有变量来取代它们, 这样可以避免额外的函数调用开销. 当添加更多功能时, 你可以用属性(`property`)来保持语法的一致性.

##### 命名
> - 所谓"内部(Internal)"表示仅模块内可用, 或者, 在类内是保护或私有的.
> - 用单下划线(`_`)开头表示模块变量或函数是`protected`的(使用`import * from`时不会包含).
> - 用双下划线(`__`)开头的实例变量或方法表示类内私有.
> - 将相关的类和顶级函数放在同一个模块里. 不像`Java`, 没必要限制一个类一个模块.
> - 对类名使用大写字母开头的单词(如`CapWords`, 即`Pascal`风格), 但是模块名应该用小写加下划线的方式(如`lower_with_under.py`). 尽管已经有很多现存的模块使用类似于`CapWords.py`这样的命名, 但现在已经不鼓励这样做, 因为如果模块名碰巧和类名一致, 这会让人困扰.

|	Type 	|   Public | 	Internal
| :------ |:-------| :------------ |
|Packages    |	lower_with_under  |
| |
|Modules  |	lower_with_under	|	_lower_with_under
| |
|Classes  |	CapWords   |	_CapWords
| |
|Exceptions    |	CapWords      |
| |
|Functions    |	lower_with_under()	|	_lower_with_under()
| |
|Global/Class Constants   |	CAPS_WITH_UNDER		|	_CAPS_WITH_UNDER
| |
|Global/Class Variables   |	lower_with_under	|	_lower_with_under
| |
|Instance Variables   	|	lower_with_under	|	_lower_with_under (protected) or __lower_with_under (private)
| |
|Method Names  		|	lower_with_under()	|	_lower_with_under() (protected) or	__lower_with_under() (private)
| |
|Function/Method Parameters		|	lower_with_under  |
| |
|Local Variables   		|	lower_with_under  |
| |

#####  Main
> 即使是一个打算被用作脚本的文件, 也应该是可导入的. 并且简单的导入不应该导致这个脚本的主功能(`main functionality`)被执行, 这是一种副作用. 主功能应该放在一个`main()`函数中.

在`Python`中, `pydoc`以及单元测试要求模块必须是可导入的. 你的代码应该在执行主程序前总是检查 `if __name__ == '__main__'` , 这样当模块被导入时主程序就不会被执行.
``` python
def main():
      ...

if __name__ == '__main__':
    main()
```
所有的顶级代码在模块导入时都会被执行. 要小心不要去调用函数, 创建对象, 或者执行那些不应该在使用`pydoc`时执行的操作.



#### 2. Python 文档注释规范


#### 3. Python for odoo 项目规范


#### 0. 参考

> - [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
> - [Google Python编码规范 (中译)](http://wiki.jikexueyuan.com/project/google-python-style-guide/python-style-rules.html])

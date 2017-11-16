---
title: PHP unserialize() [function.unserialize]: Error at offset
date: 11/16/2017 18:00
categories:
- 学以致用
- WordPress
tags:
- WordPress
- PHP
- MySQL
---

These days I meet a strange issue that I tried to publish my WordPress site from local hosted to a cloud Linux environment.

local php --, mysql --
cloud php --, mysql --

After days' deep investigation (a php starter) I found that the root cause is the `unserialize()` issue. There is a function `maybe_unserialize` in source code as following, that process an unsafe `@unserialize` the original data from MySQL databaes.

```php
function maybe_unserialize($original)
{
    if (is_serialized($original)) {
        return @unserialize($original);
    }
    return $original;
}
```

For example, as following it would throw an error that `Error at offset xx of xx bytes in [...]` and return `bool(false)`;

```php
$opt ='a:2:{s:36:"field_a";s:2:"on";s:31:"field_b";s:2:"off";}';
var_dump(maybe_unserialize($opt)) ;

//output
<br /> <b>Notice</b>: unserialize(): Error at offset 47 of 55 bytes in <b>[...][...]</b> on line <b>69</b><br /> bool(false)
```

Above issue, caused by different database charest encoding between from both MySQL databases, that can be resolve by following two steps.

#### step 1 - correct existing mis-match encoding data

Add a new method `serialize_corrector` and apply it **before** a serialized data from `unserialize` (do a correction).

```php
function serialize_corrector($data){
return preg_replace_callback('!s:(\d+):"(.*?)";!', function($m) { return 's:'.strlen($m[2]).':"'.$m[2].'";'; }, $data);
}

function maybe_unserialize( $original ) {
	if ( is_serialized( $original ) ){
		   return   unserialize( serialize_corrector ($original) );
	   // return   unserialize(   $original  );
	}
	return $original;
}
```
then

```php
function serialize_corrector($data){
    return preg_replace_callback('!s:(\d+):"(.*?)";!', function($m) { return 's:'.strlen($m[2]).':"'.$m[2].'";'; }, $data);
}

function maybe_unserialize( $original ) {
	if ( is_serialized( $original ) )
	  return unserialize( serialize_corrector ($original) );
	return $original;
}

$opt ='a:2:{s:36:"field_a";s:2:"on";s:31:"field_b";s:2:"off";}';
var_dump(maybe_unserialize($opt)) ;

// output
array(2) { ["field_a"]=> string(2) "on" ["field_b"]=> string(3) "off" }
```


####  step 2 - update database encoding
 - update the datbase `charset` to `utf8mb4 -- UTF-8 Unicode`
 - update the database `collation` to `utf8mb4_unicode_ci`


#### References
[unserialize() [function.unserialize]: Error at offset](https://stackoverflow.com/questions/10152904/unserialize-function-unserialize-error-at-offset/)
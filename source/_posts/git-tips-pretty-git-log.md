---
title: Pretty Git Log
date: 06/06/2017
category: Tips
tags:
    - Git
    - Tips
---


### `git log`

`git log` is the command to list git change history. the default `git log` console output is not that pretty as following.

```bash
    git log --max-count=5
```

<pre style="background-color: #272822">
    <span style="color: #CACACA;background-color: #272822;"></span>
    <span style="color: #8DD006;background-color: #272822;">C:\Workspace\xiao-fang.github.io </span><span style="color: #F3044B;background-color: #272822;">(hexo) </span><span style="color: #CACACA;background-color: #272822;"></span>
    <span style="color: #7C7C7C;background-color: #272822;">λ </span><span style="color: #CACACA;background-color: #272822;">git log --max-count=5 </span>
    <span style="color: #B6B649;background-color: #272822;">commit f4f30751999a62428347a3681f3dea175d6301d2</span><span style="color: #CACACA;background-color: #272822;"></span>
    <span style="color: #CACACA;background-color: #272822;">Author: xiao-fang &lt;xf@xxmail.com&gt;</span>
    <span style="color: #CACACA;background-color: #272822;">Date: Mon Jun 5 16:47:28 2017 +0800 </span>
    <span style="color: #CACACA;background-color: #272822;"></span>
    <span style="color: #CACACA;background-color: #272822;">add a new post 'pretty git log', and update an old post </span>
    <span style="color: #CACACA;background-color: #272822;"></span>
    <span style="color: #B6B649;background-color: #272822;">commit 9c883d710af69845cce226632cdd7bb361fbab3c</span><span style="color: #CACACA;background-color: #272822;"></span>
    <span style="color: #CACACA;background-color: #272822;">Author: xiao-fang &lt;xf@xxmail.com&gt;</span>
    <span style="color: #CACACA;background-color: #272822;">Date: Fri Jun 2 18:16:08 2017 +0800 </span>
    <span style="color: #CACACA;background-color: #272822;"></span>
    <span style="color: #CACACA;background-color: #272822;">update adminKey for algolia with TRAVIS env var. </span>
    <span style="color: #CACACA;background-color: #272822;"></span>
    <span style="color: #B6B649;background-color: #272822;">commit a6e7c00d6200629f62a9d402659a2910d5beda44</span><span style="color: #CACACA;background-color: #272822;"></span>
    <span style="color: #CACACA;background-color: #272822;">Author: xiao-fang &lt;xf@xxmail.com&gt;</span>
    <span style="color: #CACACA;background-color: #272822;">Date: Fri Jun 2 18:02:53 2017 +0800 </span>
    <span style="color: #CACACA;background-color: #272822;"></span>
    <span style="color: #CACACA;background-color: #272822;">update adminKey for algolia. </span>
    <span style="color: #CACACA;background-color: #272822;"></span>
    <span style="color: #B6B649;background-color: #272822;">commit 579b0cab229fe60000dfda03bc2d935bfa742ce3</span><span style="color: #CACACA;background-color: #272822;"></span>
    <span style="color: #CACACA;background-color: #272822;">Author: xiao-fang &lt;xf@xxmail.com&gt;</span>
    <span style="color: #CACACA;background-color: #272822;">Date: Fri Jun 2 17:14:55 2017 +0800 </span>
    <span style="color: #CACACA;background-color: #272822;"></span>
    <span style="color: #CACACA;background-color: #272822;">integrated 'hexo-algolia' search feature. update algolia version from 1.01. to 0.2.0 </span>
    <span style="color: #CACACA;background-color: #272822;"></span>
    <span style="color: #B6B649;background-color: #272822;">commit 233120a04db71f3eca60f3524e0cab287f302b4c</span><span style="color: #CACACA;background-color: #272822;"></span>
    <span style="color: #CACACA;background-color: #272822;">Author: xiao-fang &lt;xf@xxmail.com&gt;</span>
    <span style="color: #CACACA;background-color: #272822;">Date: Fri Jun 2 17:05:59 2017 +0800 </span>
    <span style="color: #CACACA;background-color: #272822;"></span>
    <span style="color: #CACACA;background-color: #272822;">integrated 'hexo-algolia' search feature. </span>
<br>
</pre>

<!-- more -->

### git `Pretty` log

here is my `git log pretty scheme`, let's compare it with `git log` default output style.
```bash
git config --global alias.hist "log --pretty=format:'%C(yellow)[%ad]%C(reset) %C(green)[%h]%C(reset) | %s %C(bold red)%d%C(reset) %C(green)[%an]%C(reset)' --graph --date=short"
```
looks like as following.

<pre style="background-color: #272822">
    <br>
    <span style="color: #8DD006; background-color: #272822; ">C:\Workspace\xiao-fang.github.io </span><span style="color: #F3044B; background-color: #272822; ">(hexo) </span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #7C7C7C; background-color: #272822; ">λ </span><span style="color: #CACACA; background-color: #272822; ">git hist --max-count=20 </span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-06-02]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[9c883d7]</span><span style="color: #CACACA; background-color: #272822; ">| update adminKey for algolia with TRAVIS env var. </span><span style="color: #F3044B; background-color: #272822; ">(HEAD -&gt; hexo, origin/hexo)</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-06-02]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[a6e7c00]</span><span style="color: #CACACA; background-color: #272822; ">| update adminKey for algolia. </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-06-02]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[579b0ca]</span><span style="color: #CACACA; background-color: #272822; ">| integrated 'hexo-algolia' search feature. update algolia version from 1.01. to 0.2.0 </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-06-02]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[233120a]</span><span style="color: #CACACA; background-color: #272822; ">| integrated 'hexo-algolia' search feature. </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-06-02]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[eaaccc9]</span><span style="color: #CACACA; background-color: #272822; ">| move 'clr-via-cs-01' from _posts to _drafts. </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-06-02]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[bdc542d]</span><span style="color: #CACACA; background-color: #272822; ">| add 'server-world.info' homepage link. </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-06-02]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[9b8beaf]</span><span style="color: #CACACA; background-color: #272822; ">| update 'window-threading' post </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-06-02]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[3a95f39]</span><span style="color: #CACACA; background-color: #272822; ">| update header/content-wrapper width to 80% </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-06-02]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[6301b70]</span><span style="color: #CACACA; background-color: #272822; ">| update header/content-wrapper width to 80% </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-06-02]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[96bfa34]</span><span style="color: #CACACA; background-color: #272822; ">| update window-thread post, table </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-06-02]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[be2aaac]</span><span style="color: #CACACA; background-color: #272822; ">| update table-layout: fixed to auto </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-06-02]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[97387fd]</span><span style="color: #CACACA; background-color: #272822; ">| turn off animation. </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-06-02]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[5f7401b]</span><span style="color: #CACACA; background-color: #272822; ">| update `windows threading` post </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-05-26]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[232e708]</span><span style="color: #CACACA; background-color: #272822; ">| update `windows threading` post </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-05-26]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[adc8be1]</span><span style="color: #CACACA; background-color: #272822; ">| update `windows threading` post </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-05-22]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[a6028dc]</span><span style="color: #CACACA; background-color: #272822; ">| update draft post 'clr via cs - execution model' typo issue </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-05-22]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[5ba5652]</span><span style="color: #CACACA; background-color: #272822; ">| update draft post 'clr via cs - execution model' resources </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-05-22]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[2c59263]</span><span style="color: #CACACA; background-color: #272822; ">| update draft post 'windows threading'; add new draft post 'clr via cs - execution model' </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-05-17]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[8445888]</span><span style="color: #CACACA; background-color: #272822; ">| update draft post 'windows threading' </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <span style="color: #CACACA; background-color: #272822; ">* </span><span style="color: #B6B649; background-color: #272822; ">[2017-05-17]</span><span style="color: #CACACA; background-color: #272822; "></span><span style="color: #74AA04; background-color: #272822; ">[3e39b9a]</span><span style="color: #CACACA; background-color: #272822; ">| update draft post 'windows threading' </span><span style="color: #74AA04; background-color: #272822; ">[xiao-fang]</span><span style="color: #CACACA; background-color: #272822; "></span>
    <br>
</pre>


### Reference

- [2.3 Git Basics - Viewing the Commit History](https://git-scm.com/book/en/v2/Git-Basics-Viewing-the-Commit-History)

- [Git History with Pretty Format](https://git-scm.com/docs/pretty-formats)
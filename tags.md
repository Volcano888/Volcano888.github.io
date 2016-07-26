---
layout: page
title: "标签"
description: ""  
header-img: "img/semantic.jpg"  
---

##本页使用方法

1. 在下面选一个你喜欢的文章
2. 点击它
3. 相关的文章会「唰」地一声跳到页面顶端
4. 马上试试？

##文章列表

<!--
<div id='tag_cloud'>
{% for tag in site.tags %}
<a href="#{{ tag[0] }}" title="{{ tag[0] }}" rel="{{ tag[1].size }}">{{ tag[0] }}</a>
{% endfor %}
</div>

<ul class="listing">
{% for tag in site.tags %}
  <li class="listing-seperator" id="{{ tag[0] }}">{{ tag[0] }}</li>
{% for post in tag[1] %}
  <li class="listing-item">
  <time datetime="{{ post.date | date:"%Y-%m-%d" }}">{{ post.date | date:"%Y-%m-%d" }}</time>
  <a href="{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a>
  </li>
{% endfor %}
{% endfor %}
</ul>

<script src="/media/js/jquery.tagcloud.js" type="text/javascript" charset="utf-8"></script> 
<script language="javascript">
$.fn.tagcloud.defaults = {
    size: {start: 1, end: 1, unit: 'em'},
      color: {start: '#f8e0e6', end: '#ff3333'}
};

$(function () {
    $('#tag_cloud a').tagcloud();
});
</script>
-->



<p></p>

<div id='tagcloud' >
    {% for tag in site.tags %}
    <a href="{{site.url_tags}}#{{ tag[0] }}" title="{{ tag[0] }}" rel="{{ tag[1].size }}">#{{ tag[0] }}</a>
    {% endfor %}
</div>
<script src="/js/min/jquery.tagcloud.min.js"></script>
<script type="text/javascript">
    $.fn.tagcloud.defaults = {
        size: {start: 12, end: 25, unit: 'pt'},
        color: {start: '#90a0dd', end: '#0cf'}
    };
    $(function () {
        $('#tagcloud a').tagcloud();
    });

</script>


<div class="f5">
    {% for tag in site.tags %}
    <div class="column fJqueryba">
        <h2 class=""><a name="{{ tag[0] }}"></a>{{ tag[0] }}</h2>
        <ul class="columnUl">
            {% for post in tag[1] %}
            <li>
                <b><a href="{{ post.url  }}" title="" class="gray_2" target="_blank">{{ post.title }}</a></b>
            </li>
            <!-- weiyi.theme.modify 归档页面增加文章描述
            <br><font color="gray">{{ post.description }}</font></br>
            -->
            {% endfor %}
        </ul>
    </div>
    {% endfor %}
</div>


<link rel="stylesheet" href="/css/min/type.css" type="text/css"  media="screen" />
<script src="/js/min/jquery.highight.min.js"></script>
<script type="text/javascript">
    $(function(){
        $(".f5").jquerybaHighlight({HighlightClass:"Highlight"});
    });
</script>
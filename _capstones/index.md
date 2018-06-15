---
permalink: /capstones/index.html
layout: default
---

{% for page in site.data.capstones %}
<div class="capstone card" markdown="1">
{{page.title}}
{: .head}

[Start the lesson](/capstones/{{page.url}}/)
{: .launch}

📢 [Give feedback]({{ site.github }}/issues/{{page.issue}}/)

🚩 [See issues]({{ site.github }}/labels/{{page.tag}}/)

ℹ️ {{page.status}}

{% for lesson in site.capstones %}{% if lesson.title == page.title %}{% assign words = lesson.content | number_of_words %}{% if words < site.readingspeed %}🕗 1 min{% else %}🕗 {{ words | divided_by: site.readingspeed }} mins{% endif %}{% endif %}{% endfor %}

📖 Key concepts
{% for topic in page.topics %}
- {{topic}}{% endfor %}
</div>
{% endfor %}

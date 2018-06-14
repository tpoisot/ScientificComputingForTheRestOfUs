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

🕗 {{page.time}}

ℹ️ {{page.status}}

📖 Key concepts
{% for topic in page.topics %}
- {{topic}}{% endfor %}
</div>
{% endfor %}

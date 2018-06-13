---
permalink: /lessons/index.html
layout: default
---

{% for page in site.data.lessons %}
## {{page.title}}

🏁 [Start the lesson](/lessons/{{page.url}}/)

🚩 [Report issues or give feedback][l1issues] **TODO**

🕗 {{page.time}}

ℹ️ {{page.status}}

📖 Key concepts
{% for topic in page.topics %}
- {{topic}}
{% endfor %}



{% endfor %}

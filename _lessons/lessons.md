---
permalink: /lessons/index.html
layout: default
---

{% for page in site.data.lessons %}
## {{page.title}}

🏁 [Start the lesson](/lessons/{{page.url}}/)

🚩 [Report issues or give feedback][l1issues]

📖 Contents
{% for topic in page.topics %}
1. {{topic}}
{% endfor %}

{% endfor %}

 [Start the lesson!][l1]

🚩 [Report issues or give feedback][l1issues]

📖 Contents:

1. programming as a language (with only three words!)
1. if, for, while - what do they do?
1. arrays
1. moving across loops

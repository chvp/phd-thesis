f = open('submissions.csv')
for i, line in enumerate(f):
    line = line.strip()
    date, num = line.split(',')
    date = date.replace('-', '')
    num = int(num)
    print(f"""    <rect
       style="fill:#ffffff;fill-opacity:0.33;stroke-width:0.000540929;stroke:none;stroke-opacity:1"
       id="hist{date}"
       width="{352.6 / 2772}"
       height="{num * (200 / 38771)}"
       x="{i * 352.6 / 2772}"
       y="{240 - num * (200 / 38771)}"
       inkscape:label="hist{date}" />""")

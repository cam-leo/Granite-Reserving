project = "Granite Reserving"
language = "en"
root_doc = "index"

extensions = ["myst_parser"]
myst_enable_extensions = ["dollarmath"]

html_theme = "pydata_sphinx_theme"
html_title = project
html_baseurl = "https://cam-leo.github.io/Granite-Reserving/"
html_theme_options = {
    "logo": {"text": project},
    "github_url": "https://github.com/cam-leo/Granite-Reserving",
    "navbar_align": "left",
    "show_nav_level": 1,
}

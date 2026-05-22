{
    "name": "Chèvrerie du Rocher — Site web",
    "version": "17.0.1.0.0",
    "summary": "Thème et personnalisations du site (mohair, coopérative SICA)",
    "description": "Thème nature/artisan et snippets pour le site web — éleveuse mohair",
    "author": "La Chèvrerie du Rocher",
    "category": "Website",
    "depends": ["website"],
    "data": [
        "views/layout.xml",
        "views/snippets.xml",
        "views/home.xml",
    ],
    "assets": {
        "web.assets_frontend": [
            "chevrerie_website/static/src/scss/_variables.scss",
            "chevrerie_website/static/src/scss/theme.scss",
            "chevrerie_website/static/src/scss/hero.scss",
            "chevrerie_website/static/src/scss/intro_story.scss",
            "chevrerie_website/static/src/scss/wool_grid.scss",
            "chevrerie_website/static/src/scss/savoirfaire.scss",
            "chevrerie_website/static/src/scss/visit.scss",
            "chevrerie_website/static/src/scss/markets.scss",
        ],
    },
    "installable": True,
    "application": False,
    "license": "LGPL-3",
}

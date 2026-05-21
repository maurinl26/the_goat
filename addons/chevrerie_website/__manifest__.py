{
    "name": "Chèvrerie du Rocher — Site web",
    "version": "17.0.1.0.0",
    "summary": "Thème et personnalisations du site de la Chèvrerie du Rocher",
    "description": "Thème nature/artisan et snippets pour le site web de la Chèvrerie du Rocher",
    "author": "La Chèvrerie du Rocher",
    "category": "Website",
    "depends": ["website"],
    "data": [
        "views/layout.xml",
        "views/snippets.xml",
    ],
    "assets": {
        "web.assets_frontend": [
            "chevrerie_website/static/src/scss/_variables.scss",
            "chevrerie_website/static/src/scss/theme.scss",
            "chevrerie_website/static/src/scss/hero.scss",
            "chevrerie_website/static/src/scss/markets.scss",
        ],
    },
    "installable": True,
    "application": False,
    "license": "LGPL-3",
}

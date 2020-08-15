# Python staging RESTFULL API

## Gebruik API

* python 3.8 minimum
* zet in `config.ini` de correcte waardes.
>Let op: API werkt met sqlserver windows 10 authenticatie. Om username en password te gebruiken switch de connection string in `sql_mapper.py`
* start command prompt in `PiStatingAPI/`
* run: ``pip install -r requirements.txt``
* run: ``python -m main``

## Omschrijving API

    |───controller
    |   └───controller.py           bevat de controller klasse. Hierin staat de logic van het API
    |───repository
    |   |───mongo_repository.py     bevat de nodig functies om mongoDB te gebruiken
    |   └───sql_repository.py       bevat de nodig functies om SQL server te gebruiken
    |───view
    |   └───view.py                 bevat de endpoint die de controller laag aanroept. Een enkel endpoint is aanwezig om de gehele mongoDB te refreshen
    |───tests
    |   |───test_controller.py      tests voor de controller laag
    |   |───sql_repository.py       tests voor de sql repository laag
    |   └───test_view.py            tests voor de view laag
    |───main.py                     bevat de verbinding tussen de fastAPI client en de view laag. Ook staat hier de trigger om de applicatie te starten.
    |───config.ini                  bevat de configuratie voor het API. (Settings voor SQL en Mongo)
    └───requirements.txt            bevat alle packages die nodig zijn voor alle code in dit python project dus ook het unittest framework. gebruik het bovenstaande command om deze te installeren.
    
### Json structuur
Hieronder staat een sample van de json data die door het API wordt gebruikt.
```json
[{
        "student_no": 1,
        "exam_id": "1",
        "group_id": "Standaard",
        "class_id": "ISE-A",
        "result": 1.88,
        "a": [{
                "answer_rating": false,
                "answer_fill_in_date": "2019-04-13T11:31:21.873",
                "question_no": 1
            },
            {
                "answer_rating": true,
                "answer_fill_in_date": "2019-04-13T11:46:42.383",
                "question_no": 2
            },
            {
                "answer_rating": false,
                "answer_fill_in_date": "2019-04-13T12:01:56.967",
                "question_no": 3
            },
            {
                "answer_rating": false,
                "answer_fill_in_date": "2019-04-13T12:29:01.823",
                "question_no": 4
            }
        ]
    },
    {
        "student_no": 2,
        "exam_id": "1",
        "group_id": "Dyslexie",
        "class_id": "ISE-A",
        "result": 5.00,
        "a": [{
                "answer_rating": false,
                "answer_fill_in_date": "2019-04-13T11:21:35.523",
                "question_no": 1
            },
            {
                "answer_rating": true,
                "answer_fill_in_date": "2019-04-13T11:32:19.163",
                "question_no": 2
            },
            {
                "answer_rating": false,
                "answer_fill_in_date": "2019-04-13T12:04:02.163",
                "question_no": 3
            },
            {
                "answer_rating": false,
                "answer_fill_in_date": "2019-04-13T12:28:50.380",
                "question_no": 4
            }
        ]
    },
    {
        "student_no": 1,
        "exam_id": "DB-1",
        "group_id": "Standaard",
        "class_id": "ISE-A",
        "result": 0.00,
        "a": [{
                "answer_rating": true,
                "answer_fill_in_date": "2019-04-13T11:31:21.873",
                "question_no": 1
            },
            {
                "answer_rating": true,
                "answer_fill_in_date": "2019-04-13T11:46:42.383",
                "question_no": 2
            },
            {
                "answer_rating": false,
                "answer_fill_in_date": "2019-04-13T12:01:56.967",
                "question_no": 3
            },
            {
                "answer_rating": false,
                "answer_fill_in_date": "2019-04-13T12:29:01.823",
                "question_no": 4
            },
            {
                "answer_rating": false,
                "answer_fill_in_date": "2019-04-13T11:31:21.873",
                "question_no": 9
            }
        ]
    }
]
```

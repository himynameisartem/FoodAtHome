//
//  FoodData.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.05.2022.
//

import Foundation

let vegitables = [Vegetables(name: "Adzuki beans", type: .vegetables, calories: "128"),
                  Vegetables(name: "African bird's eye chili", type: .vegetables, calories: "40"),
                  Vegetables(name: "African horned cucumber", type: .vegetables, calories: "14"),
                  Vegetables(name: "Ancho", type: .vegetables, calories: "40"),
                  Vegetables(name: "Apple pepper", type: .vegetables, calories: "26"),
                  Vegetables(name: "Artichoke", type: .vegetables, calories: "47"),
                  Vegetables(name: "Baby carrots", type: .vegetables, calories: "41"),
                  Vegetables(name: "Baby corn", type: .vegetables, calories: "24"),
                  Vegetables(name: "Bean sprouts", type: .vegetables, calories: "32"),
                  Vegetables(name: "Beans", type: .vegetables, calories: "-"),
                  Vegetables(name: "Beetroot", type: .vegetables, calories: "43"),
                  Vegetables(name: "Bell pepper", type: .vegetables, calories: "31"),
                  Vegetables(name: "Beluga lentils", type: .vegetables, calories: "336"),
                  Vegetables(name: "Bitter melon", type: .vegetables, calories: "17"),
                  Vegetables(name: "Black beans", type: .vegetables, calories: "132"),
                  Vegetables(name: "Black garlic", type: .vegetables, calories: "106"),
                  Vegetables(name: "Black olives", type: .vegetables, calories: "115"),
                  Vegetables(name: "Black radish", type: .vegetables, calories: "21"),
                  Vegetables(name: "Black salsify", type: .vegetables, calories: "87"),
                  Vegetables(name: "Boiled beetroot", type: .vegetables, calories: "35"),
                  Vegetables(name: "Boiled carrots", type: .vegetables, calories: "41"),
                  Vegetables(name: "Boiled potatoes", type: .vegetables, calories: "87"),
                  Vegetables(name: "Bottle gourd", type: .vegetables, calories: "14"),
                  Vegetables(name: "Breadfruit", type: .vegetables, calories: "103"),
                  Vegetables(name: "Broccoli", type: .vegetables, calories: "31"),
                  Vegetables(name: "Brussels sprouts", type: .vegetables, calories: "43"),
                  Vegetables(name: "Burdock root", type: .vegetables, calories: "72"),
                  Vegetables(name: "Butternut squash", type: .vegetables, calories: "45"),
                  Vegetables(name: "Cabbage pak choi", type: .vegetables, calories: "13"),
                  Vegetables(name: "Cabbage", type: .vegetables, calories: "25"),
                  Vegetables(name: "Canned beans in tomato sauce", type: .vegetables, calories: "83"),
                  Vegetables(name: "Canned beans", type: .vegetables, calories: "75"),
                  Vegetables(name: "Canned beets", type: .vegetables, calories: "35"),
                  Vegetables(name: "Canned black olives", type: .vegetables, calories: "115"),
                  Vegetables(name: "Canned broad beans", type: .vegetables, calories: "48"),
                  Vegetables(name: "Canned cabbage", type: .vegetables, calories: "26"),
                  Vegetables(name: "Canned carrots", type: .vegetables, calories: "37"),
                  Vegetables(name: "Canned cauliflower", type: .vegetables, calories: "27"),
                  Vegetables(name: "Canned celery", type: .vegetables, calories: "15"),
                  Vegetables(name: "Canned cherry tomatoes", type: .vegetables, calories: "19"),
                  Vegetables(name: "Canned corn cobs", type: .vegetables, calories: "76"),
                  Vegetables(name: "Canned cucumbers", type: .vegetables, calories: "12"),
                  Vegetables(name: "Canned eggplants", type: .vegetables, calories: "38"),
                  Vegetables(name: "Canned gherkins", type: .vegetables, calories: "12"),
                  Vegetables(name: "Canned green beans", type: .vegetables, calories: "25"),
                  Vegetables(name: "Canned green peas", type: .vegetables, calories: "71"),
                  Vegetables(name: "Canned green tomatoes", type: .vegetables, calories: "18"),
                  Vegetables(name: "Canned kidney beans", type: .vegetables, calories: "86"),
                  Vegetables(name: "Canned lentils", type: .vegetables, calories: "73"),
                  Vegetables(name: "Canned olives", type: .vegetables, calories: "115"),
                  Vegetables(name: "Canned onions", type: .vegetables, calories: "24"),
                  Vegetables(name: "Canned radish", type: .vegetables, calories: "23"),
                  Vegetables(name: "Canned squash", type: .vegetables, calories: "16"),
                  Vegetables(name: "Canned sweet pepper", type: .vegetables, calories: "26"),
                  Vegetables(name: "Canned tomatoes", type: .vegetables, calories: "17"),
                  Vegetables(name: "Canned vegetables", type: .vegetables, calories: "34"),
                  Vegetables(name: "Canned white beans", type: .vegetables, calories: "77"),
                  Vegetables(name: "Canned whole tomatoes", type: .vegetables, calories: "20"),
                  Vegetables(name: "Canned zucchini", type: .vegetables, calories: "14"),
                  Vegetables(name: "Cape gooseberry", type: .vegetables, calories: "53"),
                  Vegetables(name: "Carrot sticks", type: .vegetables, calories: "41"),
                  Vegetables(name: "Carrot", type: .vegetables, calories: "41"),
                  Vegetables(name: "Cayenne pepper", type: .vegetables, calories: "40"),
                  Vegetables(name: "Celery root", type: .vegetables, calories: "17"),
                  Vegetables(name: "Cherry tomatoes", type: .vegetables, calories: "18"),
                  Vegetables(name: "Chili pepper", type: .vegetables, calories: "40"),
                  Vegetables(name: "Chinese cabbage", type: .vegetables, calories: "12"),
                  Vegetables(name: "Chinese cucumber", type: .vegetables, calories: "12"),
                  Vegetables(name: "Chinese radish", type: .vegetables, calories: "16"),
                  Vegetables(name: "Chipotle pepper", type: .vegetables, calories: "40"),
                  Vegetables(name: "Chives", type: .vegetables, calories: "30"),
                  Vegetables(name: "Colchic kole", type: .vegetables, calories: "24"),
                  Vegetables(name: "Colorful cabbage", type: .vegetables, calories: "25"),
                  Vegetables(name: "Cooked lentils", type: .vegetables, calories: "116"),
                  Vegetables(name: "Corn on the cob", type: .vegetables, calories: "86"),
                  Vegetables(name: "Corn", type: .vegetables, calories: "86"),
                  Vegetables(name: "Cowpea", type: .vegetables, calories: "66"),
                  Vegetables(name: "Cucumber", type: .vegetables, calories: "15"),
                  Vegetables(name: "Daikon", type: .vegetables, calories: "18"),
                  Vegetables(name: "Dried beets", type: .vegetables, calories: "318"),
                  Vegetables(name: "Dried cabbage", type: .vegetables, calories: "350"),
                  Vegetables(name: "Dried horseradish", type: .vegetables, calories: "48"),
                  Vegetables(name: "Dried potatoes", type: .vegetables, calories: "307"),
                  Vegetables(name: "Dried vegetables", type: .vegetables, calories: "333"),
                  Vegetables(name: "Edamame", type: .vegetables, calories: "122"),
                  Vegetables(name: "Eggplant", type: .vegetables, calories: "25"),
                  Vegetables(name: "Fried onions", type: .vegetables, calories: "407"),
                  Vegetables(name: "Fried potatoes", type: .vegetables, calories: "319"),
                  Vegetables(name: "Frozen french fries", type: .vegetables, calories: "130"),
                  Vegetables(name: "Frozen vegetable mix", type: .vegetables, calories: "31"),
                  Vegetables(name: "Garden radish", type: .vegetables, calories: "16"),
                  Vegetables(name: "Garlic", type: .vegetables, calories: "149"),
                  Vegetables(name: "Gherkin", type: .vegetables, calories: "12"),
                  Vegetables(name: "Glazed carrots", type: .vegetables, calories: "109"),
                  Vegetables(name: "Green beans", type: .vegetables, calories: "31"),
                  Vegetables(name: "Green garlic", type: .vegetables, calories: "149"),
                  Vegetables(name: "Green peas", type: .vegetables, calories: "84"),
                  Vegetables(name: "Green tomatoes", type: .vegetables, calories: "23"),
                  Vegetables(name: "Habanero pepper", type: .vegetables, calories: "40"),
                  Vegetables(name: "Hot pepper", type: .vegetables, calories: "40"),
                  Vegetables(name: "Indian bitter gourd", type: .vegetables, calories: "20"),
                  Vegetables(name: "Jalapeño pepper", type: .vegetables, calories: "29"),
                  Vegetables(name: "Jerusalem artichoke", type: .vegetables, calories: "73"),
                  Vegetables(name: "Jicama", type: .vegetables, calories: "38"),
                  Vegetables(name: "Kale", type: .vegetables, calories: "35"),
                  Vegetables(name: "Kidney bean", type: .vegetables, calories: "127"),
                  Vegetables(name: "Kidney beans", type: .vegetables, calories: "127"),
                  Vegetables(name: "Kohlrabi", type: .vegetables, calories: "41"),
                  Vegetables(name: "Korean-style beets", type: .vegetables, calories: "21"),
                  Vegetables(name: "Korean-style carrots", type: .vegetables, calories: "32"),
                  Vegetables(name: "Lentils", type: .vegetables, calories: "116"),
                  Vegetables(name: "Lightly salted cucumbers", type: .vegetables, calories: "12"),
                  Vegetables(name: "Lima beans", type: .vegetables, calories: "113"),
                  Vegetables(name: "Loofah", type: .vegetables, calories: "24"),
                  Vegetables(name: "Mexican cucumber", type: .vegetables, calories: "13"),
                  Vegetables(name: "Mexican gherkin", type: .vegetables, calories: "13"),
                  Vegetables(name: "Mexican vegetable mix", type: .vegetables, calories: "37"),
                  Vegetables(name: "Mini pepper", type: .vegetables, calories: "20"),
                  Vegetables(name: "Mirepoix", type: .vegetables, calories: "42"),
                  Vegetables(name: "Mooli", type: .vegetables, calories: "16"),
                  Vegetables(name: "Mung bean sprouts", type: .vegetables, calories: "30"),
                  Vegetables(name: "Muscat pumpkin", type: .vegetables, calories: "47"),
                  Vegetables(name: "Okra", type: .vegetables, calories: "33"),
                  Vegetables(name: "Olives", type: .vegetables, calories: "115"),
                  Vegetables(name: "Onion", type: .vegetables, calories: "40"),
                  Vegetables(name: "Parsley root", type: .vegetables, calories: "45"),
                  Vegetables(name: "Parsnip", type: .vegetables, calories: "75"),
                  Vegetables(name: "Patty pan", type: .vegetables, calories: "24"),
                  Vegetables(name: "Peas", type: .vegetables, calories: "81"),
                  Vegetables(name: "Pepperoni", type: .vegetables, calories: "494"),
                  Vegetables(name: "Pickled artichokes", type: .vegetables, calories: "23"),
                  Vegetables(name: "Pickled asparagus", type: .vegetables, calories: "17"),
                  Vegetables(name: "Pickled beans", type: .vegetables, calories: "14"),
                  Vegetables(name: "Pickled broccoli", type: .vegetables, calories: "20"),
                  Vegetables(name: "Pickled cabbage", type: .vegetables, calories: "15"),
                  Vegetables(name: "Pickled carrots", type: .vegetables, calories: "21"),
                  Vegetables(name: "Pickled cherry tomatoes", type: .vegetables, calories: "12"),
                  Vegetables(name: "Pickled chili pepper", type: .vegetables, calories: "7"),
                  Vegetables(name: "Pickled chinese cabbage", type: .vegetables, calories: "11"),
                  Vegetables(name: "Pickled colorful cabbage", type: .vegetables, calories: "13"),
                  Vegetables(name: "Pickled cucumbers", type: .vegetables, calories: "12"),
                  Vegetables(name: "Pickled daikon", type: .vegetables, calories: "19"),
                  Vegetables(name: "Pickled eggplants", type: .vegetables, calories: "41"),
                  Vegetables(name: "Pickled garlic scapes", type: .vegetables, calories: "48"),
                  Vegetables(name: "Pickled garlic", type: .vegetables, calories: "109"),
                  Vegetables(name: "Pickled gherkins", type: .vegetables, calories: "12"),
                  Vegetables(name: "Pickled green beans", type: .vegetables, calories: "10"),
                  Vegetables(name: "Pickled green garlic", type: .vegetables, calories: "4"),
                  Vegetables(name: "Pickled habanero pepper", type: .vegetables, calories: "29"),
                  Vegetables(name: "Pickled hot pepper", type: .vegetables, calories: "21"),
                  Vegetables(name: "Pickled onions", type: .vegetables, calories: "19"),
                  Vegetables(name: "Pickled patty pan", type: .vegetables, calories: "16"),
                  Vegetables(name: "Pickled potatoes", type: .vegetables, calories: "32"),
                  Vegetables(name: "Pickled pumpkin", type: .vegetables, calories: "20"),
                  Vegetables(name: "Pickled radish", type: .vegetables, calories: "11"),
                  Vegetables(name: "Pickled red onion", type: .vegetables, calories: "21"),
                  Vegetables(name: "Pickled sweet pepper", type: .vegetables, calories: "19"),
                  Vegetables(name: "Pickled tomatoes", type: .vegetables, calories: "19"),
                  Vegetables(name: "Pickled wild garlic", type: .vegetables, calories: "34"),
                  Vegetables(name: "Pickled zucchini", type: .vegetables, calories: "15"),
                  Vegetables(name: "Potato", type: .vegetables, calories: "77"),
                  Vegetables(name: "Pumpkin", type: .vegetables, calories: "26"),
                  Vegetables(name: "Purple carrot", type: .vegetables, calories: "41"),
                  Vegetables(name: "Purple potato", type: .vegetables, calories: "77"),
                  Vegetables(name: "Radish", type: .vegetables, calories: "16"),
                  Vegetables(name: "Red cabbage", type: .vegetables, calories: "31"),
                  Vegetables(name: "Red lentils", type: .vegetables, calories: "116"),
                  Vegetables(name: "Red onion", type: .vegetables, calories: "40"),
                  Vegetables(name: "Red radish", type: .vegetables, calories: "14"),
                  Vegetables(name: "Rhubarb", type: .vegetables, calories: "21"),
                  Vegetables(name: "Romanesco", type: .vegetables, calories: "25"),
                  Vegetables(name: "Root vegetables", type: .vegetables, calories: "40"),
                  Vegetables(name: "Rutabaga", type: .vegetables, calories: "35"),
                  Vegetables(name: "Salted cucumbers", type: .vegetables, calories: "12"),
                  Vegetables(name: "Salted tomatoes", type: .vegetables, calories: "15"),
                  Vegetables(name: "Sauerkraut", type: .vegetables, calories: "19"),
                  Vegetables(name: "Savoy cabbage", type: .vegetables, calories: "27"),
                  Vegetables(name: "Serrano pepper", type: .vegetables, calories: "32"),
                  Vegetables(name: "Shallot", type: .vegetables, calories: "72"),
                  Vegetables(name: "Shelled peas", type: .vegetables, calories: "81"),
                  Vegetables(name: "Snake gourd", type: .vegetables, calories: "20"),
                  Vegetables(name: "Soybean sprouts", type: .vegetables, calories: "33"),
                  Vegetables(name: "Soybeans", type: .vegetables, calories: "446"),
                  Vegetables(name: "Spring vegetable mix", type: .vegetables, calories: "43"),
                  Vegetables(name: "Sugar beet", type: .vegetables, calories: "43"),
                  Vegetables(name: "Sun-dried tomatoes", type: .vegetables, calories: "258"),
                  Vegetables(name: "Sweet potato", type: .vegetables, calories: "86"),
                  Vegetables(name: "Taro", type: .vegetables, calories: "112"),
                  Vegetables(name: "Tomato", type: .vegetables, calories: "18"),
                  Vegetables(name: "Turnip", type: .vegetables, calories: "28"),
                  Vegetables(name: "White beans", type: .vegetables, calories: "142"),
                  Vegetables(name: "White cabbage", type: .vegetables, calories: "27"),
                  Vegetables(name: "White carrot", type: .vegetables, calories: "41"),
                  Vegetables(name: "White onion", type: .vegetables, calories: "40"),
                  Vegetables(name: "White radish", type: .vegetables, calories: "14"),
                  Vegetables(name: "Winter squash", type: .vegetables, calories: "45"),
                  Vegetables(name: "Yacon", type: .vegetables, calories: "55"),
                  Vegetables(name: "Yam", type: .vegetables, calories: "118"),
                  Vegetables(name: "Yellow beetroot", type: .vegetables, calories: "43"),
                  Vegetables(name: "Yellow carrot", type: .vegetables, calories: "41"),
                  Vegetables(name: "Young potatoes", type: .vegetables, calories: "86"),
                  Vegetables(name: "Zucchini", type: .vegetables, calories: "17")]






























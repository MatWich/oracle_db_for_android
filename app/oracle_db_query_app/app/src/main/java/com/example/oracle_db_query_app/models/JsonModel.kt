package com.example.oracle_db_query_app.models

import com.beust.klaxon.Json
import com.beust.klaxon.Klaxon

private val klaxon = Klaxon()

class JsonModel(@Json(name = "cols")
                val cols: List<String>,
                @Json(name = "data")
                val data: List<List<String>>
                )

fun main() {
    val list: List<String> = listOf("sysdate", "user")
    val result = Klaxon().parse<JsonModel>("""{
        "cols": ["sysdate", "user"],
        "data": [
            [
                "Mon, 26 Jul 2021 14:40:42 GMT",
                "DEMO"
            ]
                ]
    }""")


    assert(result?.cols == list)
    println("Assertion passed")
}
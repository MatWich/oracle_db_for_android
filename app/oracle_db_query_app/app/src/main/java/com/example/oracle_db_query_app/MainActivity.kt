package com.example.oracle_db_query_app.models

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import com.example.oracle_db_query_app.R

class MainActivity : AppCompatActivity() {

    private lateinit var submitBtn: Button
    private lateinit var queryTextInput: EditText

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        submitBtn = findViewById(R.id.submit)
        submitBtn.setOnClickListener {
            switchActivities()
        }

        queryTextInput = findViewById(R.id.query_input)

    }

    private fun switchActivities() {
        val switchActivityIntent = Intent(this, DataActivity::class.java)
        val query = queryTextInput.text.toString()
        switchActivityIntent.putExtra("query", query)
        startActivity(switchActivityIntent)
    }


}
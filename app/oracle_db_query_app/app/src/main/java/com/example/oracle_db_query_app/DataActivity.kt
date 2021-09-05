package com.example.oracle_db_query_app.models

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.StrictMode
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ProgressBar
import android.widget.TextView
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.beust.klaxon.Klaxon
import com.example.oracle_db_query_app.R
import java.net.URL

class DataActivity : AppCompatActivity() {

    val dataList: MutableList<String> = ArrayList()
    private var requestr: String = "http://10.0.2.2:5000/json/"

    var isLoading = false
    var firstPage = true
    lateinit var adapter: DataAdapter
    lateinit var layoutManager: LinearLayoutManager
    lateinit var recyclerView: RecyclerView
    lateinit var progressBar: ProgressBar
    lateinit var exstras: Bundle
    private var query: String = "SELECT USER FROM DUAL"


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_data)

        recyclerView = findViewById(R.id.recyclerView)
        progressBar = findViewById(R.id.progressBar)

        /* One day it will be replaced witch sth better */
        val policy = StrictMode.ThreadPolicy.Builder().permitAll().build()
        StrictMode.setThreadPolicy(policy)

        exstras = intent.extras!!   // query is always sent here even as empty string
        val new_query = exstras.getString("query").toString()
        if (new_query != "")
            query = new_query

        // mock value for just initialisation will be changed later
        layoutManager = GridLayoutManager(this, 1)

        recyclerView.layoutManager = layoutManager
        getData()

        recyclerView.addOnScrollListener(object: RecyclerView.OnScrollListener(){
            override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                val visibleItemCount = layoutManager.childCount
                val pastVisibleItems = layoutManager.findFirstCompletelyVisibleItemPosition()
                val total = adapter.itemCount

                if (!isLoading)
                    if ((visibleItemCount + pastVisibleItems) >= total)
                        getData()
                super.onScrolled(recyclerView, dx, dy)
            }
        })
    }

    private fun getData() {
        isLoading = true
        progressBar.visibility = View.VISIBLE

        val url = requestr.plus(query.toString())
        val response = URL(url).openStream().bufferedReader().use { it.readText() }
        if ("\"data\": []" in response)
            return
        val parsedData = Klaxon().parse<JsonModel>(response)

        //headers
        if (firstPage) {
            firstPage = false
            (recyclerView.layoutManager as GridLayoutManager).spanCount = parsedData?.cols!!.size
            dataList.addAll(parsedData.cols)
        }

        for (tab in parsedData!!.data)
            dataList.addAll(tab)

        Handler(Looper.getMainLooper()).postDelayed({
            if (::adapter.isInitialized) {
                adapter.notifyDataSetChanged()
            } else {
                adapter = DataAdapter(this)
                recyclerView.adapter = adapter
            }
            isLoading = false
            progressBar.visibility = View.GONE
        }, 1000)
    }


    class DataAdapter(val activity: DataActivity) : RecyclerView.Adapter<DataAdapter.DataViewHolder>() {
        class DataViewHolder(v: View) : RecyclerView.ViewHolder(v){
            val tvData = v.findViewById<TextView>(R.id.tv_data)
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): DataViewHolder {
            return DataViewHolder(LayoutInflater.from(activity).inflate(R.layout.rv_child_data, parent, false))
        }

        override fun onBindViewHolder(holder: DataViewHolder, position: Int) {
            holder.tvData.text = activity.dataList[position]
        }

        override fun getItemCount(): Int {
            return activity.dataList.size
        }
    }

}
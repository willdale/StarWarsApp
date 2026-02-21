package uk.co.willdale.starwarsapp.Main

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.lifecycle.ViewModelProvider
import uk.co.willdale.starwarsapp.Networking.HttpClientAndroid
import uniffi.starwars.ApiClient
import uniffi.starwars.DataRepository

class MainActivity : ComponentActivity() {

    private lateinit var viewModel: MainViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        setupViewModel()

        setContent {
            MainScreen(viewModel = viewModel)
        }
    }

    private fun setupViewModel() {
        val factory = MainViewModelFactory(
            apiClient = ApiClient(
                httpClient = HttpClientAndroid(),
                repository = DataRepository()
            )
        )
        viewModel = ViewModelProvider(this, factory)[MainViewModel::class.java]
    }
}

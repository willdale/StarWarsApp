package uk.co.willdale.starwarsapp.Main

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import uniffi.starwars.*

class MainViewModel(private val apiClient: ApiClient) : ViewModel() {

    private val _uiState = MutableStateFlow<UiState<List<Any>>>(UiState.Idle)
    val uiState: StateFlow<UiState<List<Any>>> = _uiState

    private val fetchedCategories = mutableSetOf<Fetchable>()

    fun loadData(fetchable: Fetchable, urls: List<String>? = null) {
        viewModelScope.launch {
            _uiState.value = UiState.Loading
            try {
                val data: List<Any> = if (urls != null) {
                    urls.map { url ->
                        async {
                            fetchSingleItem(fetchable, url)
                        }
                    }.awaitAll()
                } else {
                    val ignoreCache = !fetchedCategories.contains(fetchable)
                    val result = when (fetchable) {
                        Fetchable.PLANETS -> apiClient.fetchPlanets(ignoreCache)
                        Fetchable.PEOPLE -> apiClient.fetchPeople(ignoreCache)
                        Fetchable.FILMS -> apiClient.fetchFilms(ignoreCache)
                        Fetchable.SPECIES -> apiClient.fetchSpeciesList(ignoreCache)
                        Fetchable.STARSHIPS -> apiClient.fetchStarships(ignoreCache)
                        Fetchable.VEHICLES -> apiClient.fetchVehicles(ignoreCache)
                    }
                    fetchedCategories.add(fetchable)
                    result
                }
                _uiState.value = UiState.Success(data)
            } catch (e: Exception) {
                _uiState.value = UiState.Error(e.message ?: "An unexpected error occurred")
            }
        }
    }

    fun loadItem(fetchable: Fetchable, url: String) {
        viewModelScope.launch {
            _uiState.value = UiState.Loading
            try {
                val item = fetchSingleItem(fetchable, url)
                _uiState.value = UiState.Success(listOf(item))
            } catch (e: Exception) {
                _uiState.value = UiState.Error(e.message ?: "An unexpected error occurred")
            }
        }
    }

    private suspend fun fetchSingleItem(fetchable: Fetchable, url: String): Any {
        return when (fetchable) {
            Fetchable.PLANETS -> apiClient.fetchPlanet(url)
            Fetchable.PEOPLE -> apiClient.fetchPerson(url)
            Fetchable.FILMS -> apiClient.fetchFilm(url)
            Fetchable.SPECIES -> apiClient.fetchSpecies(url)
            Fetchable.STARSHIPS -> apiClient.fetchStarship(url)
            Fetchable.VEHICLES -> apiClient.fetchVehicle(url)
        }
    }
}

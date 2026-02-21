package uk.co.willdale.starwarsapp

// MainViewModel.kt
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import uniffi.starwars.ApiClient

class MainViewModel(private val apiClient: ApiClient) : ViewModel() {

    private val _uiState = MutableStateFlow<UiState<*>>(UiState.Idle)
    val uiState: StateFlow<UiState<*>> = _uiState

    fun loadPlanets(forceRefresh: Boolean = false) {
        viewModelScope.launch {
            _uiState.value = UiState.Loading
            _uiState.value = try {
                val planets = apiClient.fetchPlanets(forceRefresh)
                UiState.Success(planets)
            } catch (e: Exception) {
                UiState.Error(e.message ?: "An unexpected error occurred")
            }
        }
    }
}
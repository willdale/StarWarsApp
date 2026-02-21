package uk.co.willdale.starwarsapp

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import uniffi.starwars.*

@Composable
fun DataListScreen(
    fetchable: Fetchable,
    urls: List<String>? = null,
    viewModel: MainViewModel,
    onItemClick: (Any) -> Unit
) {
    val uiState by viewModel.uiState.collectAsState()

    LaunchedEffect(fetchable, urls) {
        viewModel.loadData(fetchable, urls)
    }

    Box(modifier = Modifier.fillMaxSize()) {
        when (val state = uiState) {
            is UiState.Loading -> {
                CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
            }
            is UiState.Success -> {
                val data = state.data
                if (data.isEmpty()) {
                    Text("No results", modifier = Modifier.align(Alignment.Center))
                } else {
                    LazyColumn(modifier = Modifier.fillMaxSize()) {
                        items(data) { item ->
                            val name = when (item) {
                                is Planet -> item.name
                                is Person -> item.name
                                is Film -> item.title
                                is Species -> item.name
                                is Starship -> item.name
                                is Vehicle -> item.name
                                else -> "Unknown"
                            }
                            ListItem(
                                headlineContent = { Text(name) },
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .clickable { onItemClick(item) }
                            )
                            HorizontalDivider()
                        }
                    }
                }
            }
            is UiState.Error -> {
                Text("Error: ${state.message}", modifier = Modifier.align(Alignment.Center))
            }
            else -> {}
        }
    }
}

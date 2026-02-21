package uk.co.willdale.starwarsapp.DetailViews

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import uk.co.willdale.starwarsapp.Main.MainViewModel
import uk.co.willdale.starwarsapp.Main.UiState
import uniffi.starwars.Fetchable
import uniffi.starwars.Starship
import java.util.*

@Composable
fun StarshipDetailScreen(
    starshipUrl: String,
    viewModel: MainViewModel,
    onPilotClick: (List<String>) -> Unit,
    onFilmClick: (List<String>) -> Unit,
) {
    val uiState by viewModel.uiState.collectAsState()

    LaunchedEffect(starshipUrl) {
        viewModel.loadItem(Fetchable.STARSHIPS, starshipUrl)
    }

    Box(modifier = Modifier.fillMaxSize()) {
        when (val state = uiState) {
            is UiState.Loading -> CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
            is UiState.Success -> {
                val starship = state.data.firstOrNull() as? Starship
                if (starship != null) {
                    StarshipDetailContent(
                        starship = starship,
                        onPilotClick = onPilotClick,
                        onFilmClick = onFilmClick
                    )
                }
            }
            is UiState.Error -> Text("Error: ${state.message}", modifier = Modifier.align(Alignment.Center))
            else -> {}
        }
    }
}

@Composable
private fun StarshipDetailContent(
    starship: Starship,
    onPilotClick: (List<String>) -> Unit,
    onFilmClick: (List<String>) -> Unit,
) {
    Column(
        modifier = Modifier
            .verticalScroll(rememberScrollState())
            .padding(vertical = 24.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Header Section
        Column(
            modifier = Modifier.padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text(
                text = starship.name,
                fontSize = 34.sp,
                fontWeight = FontWeight.Bold
            )
            Row {
                Text(
                    text = starship.model,
                    color = MaterialTheme.colorScheme.secondary,
                    modifier = Modifier.weight(1f)
                )
                Text(
                    text = starship.starshipClass.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() },
                    color = MaterialTheme.colorScheme.secondary
                )
            }
        }

        HorizontalDivider()

        // Manufacturing
        Column(
            modifier = Modifier.padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text(text = "Manufacturing", fontWeight = FontWeight.Bold)
            InfoRow(label = "Manufacturer", value = starship.manufacturer)
            InfoRow(label = "Cost", value = starship.costInCredits)
            InfoRow(label = "Length", value = starship.length)
            InfoRow(label = "Consumables", value = starship.consumables)
        }

        HorizontalDivider()

        // Performance
        Column(
            modifier = Modifier.padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text(text = "Performance", fontWeight = FontWeight.Bold)
            InfoRow(label = "Max Speed", value = starship.maxAtmospheringSpeed)
            InfoRow(label = "Hyperdrive Rating", value = starship.hyperdriveRating)
            InfoRow(label = "MGLT", value = starship.mglt)
        }

        HorizontalDivider()

        // Capacity
        Column(
            modifier = Modifier.padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text(text = "Capacity", fontWeight = FontWeight.Bold)
            InfoRow(label = "Crew", value = starship.crew)
            InfoRow(label = "Passengers", value = starship.passengers)
            InfoRow(label = "Cargo Capacity", value = starship.cargoCapacity)
        }

        HorizontalDivider()

        // List Sections
        if (starship.pilots.isNotEmpty()) {
            SelectableRow(title = "Pilots") { onPilotClick(starship.pilots) }
        }
        if (starship.films.isNotEmpty()) {
            SelectableRow(title = "Films") { onFilmClick(starship.films) }
        }
    }
}

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
import uniffi.starwars.Planet
import java.util.*

@Composable
fun PlanetDetailScreen(
    planetUrl: String,
    viewModel: MainViewModel,
    onResidentClick: (List<String>) -> Unit,
    onFilmClick: (List<String>) -> Unit,
) {
    val uiState by viewModel.uiState.collectAsState()

    LaunchedEffect(planetUrl) {
        viewModel.loadItem(Fetchable.PLANETS, planetUrl)
    }

    Box(modifier = Modifier.fillMaxSize()) {
        when (val state = uiState) {
            is UiState.Loading -> CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
            is UiState.Success -> {
                val planet = state.data.firstOrNull() as? Planet
                if (planet != null) {
                    PlanetDetailContent(
                        planet = planet,
                        onResidentClick = onResidentClick,
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
private fun PlanetDetailContent(
    planet: Planet,
    onResidentClick: (List<String>) -> Unit,
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
                text = planet.name,
                fontSize = 34.sp,
                fontWeight = FontWeight.Bold
            )
            Row {
                Text(
                    text = planet.climate.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() },
                    color = MaterialTheme.colorScheme.secondary
                )
                Spacer(modifier = Modifier.weight(1f))
                Text(
                    text = "Pop. ${planet.population}",
                    color = MaterialTheme.colorScheme.secondary
                )
            }
        }

        HorizontalDivider()

        // Geography
        Column(
            modifier = Modifier.padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text(text = "Geography", fontWeight = FontWeight.Bold)
            InfoRow(
                label = "Terrain",
                value = planet.terrain.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() })
            InfoRow(label = "Diameter", value = planet.diameter)
            InfoRow(label = "Surface Water", value = planet.surfaceWater)
            InfoRow(label = "Gravity", value = planet.gravity)
        }

        HorizontalDivider()

        // Orbital Data
        Column(
            modifier = Modifier.padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text(text = "Orbital Data", fontWeight = FontWeight.Bold)
            InfoRow(label = "Rotation Period", value = planet.rotationPeriod)
            InfoRow(label = "Orbital Period", value = planet.orbitalPeriod)
        }

        HorizontalDivider()

        // List Sections
        if (planet.residents.isNotEmpty()) {
            SelectableRow(title = "Residents") { onResidentClick(planet.residents) }
        }
        if (planet.films.isNotEmpty()) {
            SelectableRow(title = "Films") { onFilmClick(planet.films) }
        }
    }
}

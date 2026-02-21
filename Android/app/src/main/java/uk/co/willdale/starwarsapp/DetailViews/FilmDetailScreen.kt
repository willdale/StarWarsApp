package uk.co.willdale.starwarsapp.DetailViews

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import uk.co.willdale.starwarsapp.Main.MainViewModel
import uk.co.willdale.starwarsapp.Main.UiState
import uniffi.starwars.Fetchable
import uniffi.starwars.Film

@Composable
fun FilmDetailScreen(
    filmUrl: String,
    viewModel: MainViewModel,
    onCharacterClick: (List<String>) -> Unit,
    onPlanetClick: (List<String>) -> Unit,
    onStarshipClick: (List<String>) -> Unit,
    onVehicleClick: (List<String>) -> Unit,
    onSpeciesClick: (List<String>) -> Unit,
) {
    val uiState by viewModel.uiState.collectAsState()

    LaunchedEffect(filmUrl) {
        viewModel.loadItem(Fetchable.FILMS, filmUrl)
    }

    Box(modifier = Modifier.fillMaxSize()) {
        when (val state = uiState) {
            is UiState.Loading -> CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
            is UiState.Success -> {
                val film = state.data.firstOrNull() as? Film
                if (film != null) {
                    FilmDetailContent(
                        film = film,
                        onCharacterClick = onCharacterClick,
                        onPlanetClick = onPlanetClick,
                        onStarshipClick = onStarshipClick,
                        onVehicleClick = onVehicleClick,
                        onSpeciesClick = onSpeciesClick,
                    )
                }
            }
            is UiState.Error -> Text("Error: ${state.message}", modifier = Modifier.align(Alignment.Center))
            else -> {}
        }
    }
}

@Composable
private fun FilmDetailContent(
    film: Film,
    onCharacterClick: (List<String>) -> Unit,
    onPlanetClick: (List<String>) -> Unit,
    onStarshipClick: (List<String>) -> Unit,
    onVehicleClick: (List<String>) -> Unit,
    onSpeciesClick: (List<String>) -> Unit,
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
                text = film.title,
                fontSize = 34.sp,
                fontWeight = FontWeight.Bold
            )
            Row {
                Text(text = "Episode ${film.episodeId}")
                Spacer(modifier = Modifier.weight(1f))
                Text(text = film.releaseDate)
            }
        }

        HorizontalDivider()

        // Opening Crawl
        Column(
            modifier = Modifier.padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text(text = "Opening Crawl", fontWeight = FontWeight.Bold)
            Text(text = film.openingCrawl)
        }

        HorizontalDivider()

        // Production Info
        Column(
            modifier = Modifier.padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text(text = "Production", fontWeight = FontWeight.Bold)
            InfoRow(label = "Director", value = film.director)
            InfoRow(label = "Producer", value = film.producer)
        }

        HorizontalDivider()

        // List Sections
        if (film.characters.isNotEmpty()) {
            SelectableRow(title = "Characters") { onCharacterClick(film.characters) }
        }
        if (film.planets.isNotEmpty()) {
            SelectableRow(title = "Planets") { onPlanetClick(film.planets) }
        }
        if (film.starships.isNotEmpty()) {
            SelectableRow(title = "Starships") { onStarshipClick(film.starships) }
        }
        if (film.vehicles.isNotEmpty()) {
            SelectableRow(title = "Vehicles") { onVehicleClick(film.vehicles) }
        }
        if (film.species.isNotEmpty()) {
            SelectableRow(title = "Species") { onSpeciesClick(film.species) }
        }
    }
}

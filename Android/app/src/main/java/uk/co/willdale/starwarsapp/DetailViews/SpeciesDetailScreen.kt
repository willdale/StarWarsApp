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
import uniffi.starwars.Species
import java.util.*

@Composable
fun SpeciesDetailScreen(
    speciesUrl: String,
    viewModel: MainViewModel,
    onPeopleClick: (List<String>) -> Unit,
    onFilmClick: (List<String>) -> Unit,
    onHomeworldClick: (String) -> Unit,
) {
    val uiState by viewModel.uiState.collectAsState()

    LaunchedEffect(speciesUrl) {
        viewModel.loadItem(Fetchable.SPECIES, speciesUrl)
    }

    Box(modifier = Modifier.fillMaxSize()) {
        when (val state = uiState) {
            is UiState.Loading -> CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
            is UiState.Success -> {
                val species = state.data.firstOrNull() as? Species
                if (species != null) {
                    SpeciesDetailContent(
                        species = species,
                        onPeopleClick = onPeopleClick,
                        onFilmClick = onFilmClick,
                        onHomeworldClick = onHomeworldClick
                    )
                }
            }
            is UiState.Error -> Text("Error: ${state.message}", modifier = Modifier.align(Alignment.Center))
            else -> {}
        }
    }
}

@Composable
private fun SpeciesDetailContent(
    species: Species,
    onPeopleClick: (List<String>) -> Unit,
    onFilmClick: (List<String>) -> Unit,
    onHomeworldClick: (String) -> Unit,
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
                text = species.name,
                fontSize = 34.sp,
                fontWeight = FontWeight.Bold
            )
            Row {
                Text(
                    text = species.classification.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() },
                    color = MaterialTheme.colorScheme.secondary
                )
                Spacer(modifier = Modifier.weight(1f))
                Text(
                    text = species.designation.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() },
                    color = MaterialTheme.colorScheme.secondary
                )
            }
        }

        HorizontalDivider()

        // Biology
        Column(
            modifier = Modifier.padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text(text = "Biology", fontWeight = FontWeight.Bold)
            InfoRow(label = "Average Height", value = species.averageHeight)
            InfoRow(label = "Average Lifespan", value = species.averageLifespan)
            InfoRow(
                label = "Skin Colors",
                value = species.skinColors.replaceFirstChar {
                    if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString()
                })
            InfoRow(
                label = "Hair Colors",
                value = species.hairColors.replaceFirstChar {
                    if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString()
                })
            InfoRow(
                label = "Eye Colors",
                value = species.eyeColors.replaceFirstChar {
                    if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString()
                })
        }

        HorizontalDivider()

        // List Sections
        if (species.people.isNotEmpty()) {
            SelectableRow(title = "People") { onPeopleClick(species.people) }
        }
        if (species.films.isNotEmpty()) {
            SelectableRow(title = "Films") { onFilmClick(species.films) }
        }
        species.homeworld?.let { homeworld ->
            SelectableRow(title = "Homeworld") { onHomeworldClick(homeworld) }
        }
    }
}

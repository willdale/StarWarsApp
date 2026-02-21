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
import uniffi.starwars.Person
import java.util.*

@Composable
fun PersonDetailScreen(
    personUrl: String,
    viewModel: MainViewModel,
    onFilmClick: (List<String>) -> Unit,
    onSpeciesClick: (List<String>) -> Unit,
    onStarshipClick: (List<String>) -> Unit,
    onVehicleClick: (List<String>) -> Unit,
    onHomeworldClick: (String) -> Unit,
) {
    val uiState by viewModel.uiState.collectAsState()

    LaunchedEffect(personUrl) {
        viewModel.loadItem(Fetchable.PEOPLE, personUrl)
    }

    Box(modifier = Modifier.fillMaxSize()) {
        when (val state = uiState) {
            is UiState.Loading -> CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
            is UiState.Success -> {
                val person = state.data.firstOrNull() as? Person
                if (person != null) {
                    PersonDetailContent(
                        person = person,
                        onFilmClick = onFilmClick,
                        onSpeciesClick = onSpeciesClick,
                        onStarshipClick = onStarshipClick,
                        onVehicleClick = onVehicleClick,
                        onHomeworldClick = onHomeworldClick,
                    )
                }
            }
            is UiState.Error -> Text("Error: ${state.message}", modifier = Modifier.align(Alignment.Center))
            else -> {}
        }
    }
}

@Composable
private fun PersonDetailContent(
    person: Person,
    onFilmClick: (List<String>) -> Unit,
    onSpeciesClick: (List<String>) -> Unit,
    onStarshipClick: (List<String>) -> Unit,
    onVehicleClick: (List<String>) -> Unit,
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
                text = person.name,
                fontSize = 34.sp,
                fontWeight = FontWeight.Bold
            )
            Row {
                Text(text = "Born ${person.birthYear}", color = MaterialTheme.colorScheme.secondary)
                Spacer(modifier = Modifier.weight(1f))
                Text(
                    text = person.gender.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() },
                    color = MaterialTheme.colorScheme.secondary
                )
            }
        }

        HorizontalDivider()

        // Physical Attributes
        Column(
            modifier = Modifier.padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text(text = "Physical Attributes", fontWeight = FontWeight.Bold)
            InfoRow(label = "Height", value = person.height)
            InfoRow(label = "Mass", value = person.mass)
            InfoRow(
                label = "Eye Color",
                value = person.eyeColor.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() })
            InfoRow(
                label = "Hair Color",
                value = person.hairColor.replaceFirstChar {
                    if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString()
                })
            InfoRow(
                label = "Skin Color",
                value = person.skinColor.replaceFirstChar {
                    if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString()
                })
            InfoRow(label = "Birth Year", value = person.birthYear)
        }

        HorizontalDivider()

        // List Sections
        if (person.films.isNotEmpty()) {
            SelectableRow(title = "Films") { onFilmClick(person.films) }
        }
        if (person.species.isNotEmpty()) {
            SelectableRow(title = "Species") { onSpeciesClick(person.species) }
        }
        if (person.starships.isNotEmpty()) {
            SelectableRow(title = "Starships") { onStarshipClick(person.starships) }
        }
        if (person.vehicles.isNotEmpty()) {
            SelectableRow(title = "Vehicles") { onVehicleClick(person.vehicles) }
        }
        person.homeworld?.let { homeworld ->
            SelectableRow(title = "Homeworld") { onHomeworldClick(homeworld) }
        }
    }
}

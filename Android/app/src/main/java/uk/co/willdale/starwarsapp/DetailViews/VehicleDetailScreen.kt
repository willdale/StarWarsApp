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
import uniffi.starwars.Vehicle
import java.util.*

@Composable
fun VehicleDetailScreen(
    vehicleUrl: String,
    viewModel: MainViewModel,
    onPilotClick: (List<String>) -> Unit,
    onFilmClick: (List<String>) -> Unit,
) {
    val uiState by viewModel.uiState.collectAsState()

    LaunchedEffect(vehicleUrl) {
        viewModel.loadItem(Fetchable.VEHICLES, vehicleUrl)
    }

    Box(modifier = Modifier.fillMaxSize()) {
        when (val state = uiState) {
            is UiState.Loading -> CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
            is UiState.Success -> {
                val vehicle = state.data.firstOrNull() as? Vehicle
                if (vehicle != null) {
                    VehicleDetailContent(
                        vehicle = vehicle,
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
private fun VehicleDetailContent(
    vehicle: Vehicle,
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
                text = vehicle.name,
                fontSize = 34.sp,
                fontWeight = FontWeight.Bold
            )
            Row {
                Text(
                    text = vehicle.model,
                    color = MaterialTheme.colorScheme.secondary,
                    modifier = Modifier.weight(1f)
                )
                Text(
                    text = vehicle.vehicleClass.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() },
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
            InfoRow(label = "Manufacturer", value = vehicle.manufacturer)
            InfoRow(label = "Cost", value = vehicle.costInCredits)
            InfoRow(label = "Length", value = vehicle.length)
            InfoRow(label = "Consumables", value = vehicle.consumables)
        }

        HorizontalDivider()

        // Performance
        Column(
            modifier = Modifier.padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text(text = "Performance", fontWeight = FontWeight.Bold)
            InfoRow(label = "Max Speed", value = vehicle.maxAtmospheringSpeed)
        }

        HorizontalDivider()

        // Capacity
        Column(
            modifier = Modifier.padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text(text = "Capacity", fontWeight = FontWeight.Bold)
            InfoRow(label = "Crew", value = vehicle.crew)
            InfoRow(label = "Passengers", value = vehicle.passengers)
            InfoRow(label = "Cargo Capacity", value = vehicle.cargoCapacity)
        }

        HorizontalDivider()

        // List Sections
        if (vehicle.pilots.isNotEmpty()) {
            SelectableRow(title = "Pilots") { onPilotClick(vehicle.pilots) }
        }
        if (vehicle.films.isNotEmpty()) {
            SelectableRow(title = "Films") { onFilmClick(vehicle.films) }
        }
    }
}

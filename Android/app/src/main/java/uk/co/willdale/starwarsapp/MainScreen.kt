package uk.co.willdale.starwarsapp

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainScreen(viewModel: MainViewModel) {
    val navController = rememberNavController()
    val uiState by viewModel.uiState.collectAsState()
    val snackbarHostState = remember { SnackbarHostState() }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.app_name)) },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer,
                    titleContentColor = MaterialTheme.colorScheme.primary,
                )
            )
        },
        floatingActionButton = {
            FloatingActionButton(onClick = { /* Handle FAB click */ }) {
                Icon(Icons.Default.Add, contentDescription = "Add")
            }
        },
        snackbarHost = { SnackbarHost(snackbarHostState) }
    ) { innerPadding ->
        Box(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
        ) {
            NavHost(navController = navController, startDestination = "first") {
                composable("first") {
                    FirstScreen(onNextClick = { navController.navigate("second") })
                }
            }

            when (val state = uiState) {
                is UiState.Loading -> CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
                is UiState.Error -> {
                    LaunchedEffect(state.message) {
                        snackbarHostState.showSnackbar(
                            message = state.message,
                            actionLabel = "Retry"
                        ).let { result ->
                            if (result == SnackbarResult.ActionPerformed) {
                                viewModel.loadPlanets()
                            }
                        }
                    }
                }
                is UiState.Success -> {
                    // Handle success state if needed
                }
                else -> {}
            }
        }
    }
}

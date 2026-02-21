package uk.co.willdale.starwarsapp

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import uniffi.starwars.Fetchable

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainScreen(viewModel: MainViewModel) {
    val navController = rememberNavController()

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
    ) { innerPadding ->
        Box(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
        ) {
            NavHost(navController = navController, startDestination = "categoryList") {
                composable("categoryList") {
                    CategoryListScreen(onCategoryClick = { category ->
                        navController.navigate("dataList/${category.name}")
                    })
                }

                composable(
                    route = "dataList/{fetchable}?urls={urls}",
                    arguments = listOf(
                        navArgument("fetchable") { type = NavType.StringType },
                        navArgument("urls") {
                            type = NavType.StringType
                            nullable = true
                        }
                    )
                ) { backStackEntry ->
                    val fetchableName = backStackEntry.arguments?.getString("fetchable")
                    val fetchable = Fetchable.valueOf(fetchableName!!)
                    val urlsJson = backStackEntry.arguments?.getString("urls")
                    val urls = urlsJson?.split(",") // Basic splitting for now

                    DataListScreen(
                        fetchable = fetchable,
                        urls = urls,
                        viewModel = viewModel,
                        onItemClick = { item ->
                            // Navigate to detail screen
                        }
                    )
                }
            }
        }
    }
}

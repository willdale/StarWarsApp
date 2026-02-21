package uk.co.willdale.starwarsapp.Main

import android.net.Uri
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
import uk.co.willdale.starwarsapp.DetailViews.FilmDetailScreen
import uk.co.willdale.starwarsapp.DetailViews.PersonDetailScreen
import uk.co.willdale.starwarsapp.DetailViews.PlanetDetailScreen
import uk.co.willdale.starwarsapp.DetailViews.SpeciesDetailScreen
import uk.co.willdale.starwarsapp.DetailViews.StarshipDetailScreen
import uk.co.willdale.starwarsapp.DetailViews.VehicleDetailScreen
import uk.co.willdale.starwarsapp.Initial.CategoryListScreen
import uk.co.willdale.starwarsapp.Initial.DataListScreen
import uk.co.willdale.starwarsapp.R
import uniffi.starwars.Fetchable
import uniffi.starwars.Film
import uniffi.starwars.Person
import uniffi.starwars.Planet
import uniffi.starwars.Species
import uniffi.starwars.Starship
import uniffi.starwars.Vehicle

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
                    val urls = urlsJson?.split(",")

                    DataListScreen(
                        fetchable = fetchable,
                        urls = urls,
                        viewModel = viewModel,
                        onItemClick = { item ->
                            val url = when (item) {
                                is Film -> item.url
                                is Person -> item.url
                                is Planet -> item.url
                                is Species -> item.url
                                is Starship -> item.url
                                is Vehicle -> item.url
                                else -> ""
                            }
                            val encodedUrl = Uri.encode(url)
                            when (item) {
                                is Film -> navController.navigate("filmDetail/$encodedUrl")
                                is Person -> navController.navigate("personDetail/$encodedUrl")
                                is Planet -> navController.navigate("planetDetail/$encodedUrl")
                                is Species -> navController.navigate("speciesDetail/$encodedUrl")
                                is Starship -> navController.navigate("starshipDetail/$encodedUrl")
                                is Vehicle -> navController.navigate("vehicleDetail/$encodedUrl")
                                else -> {}
                            }
                        }
                    )
                }

                composable(
                    route = "filmDetail/{url}",
                    arguments = listOf(navArgument("url") { type = NavType.StringType })
                ) { backStackEntry ->
                    val url = backStackEntry.arguments?.getString("url") ?: ""
                    FilmDetailScreen(
                        filmUrl = Uri.decode(url),
                        viewModel = viewModel,
                        onCharacterClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.PEOPLE.name}?urls=$urlsString")
                        },
                        onPlanetClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.PLANETS.name}?urls=$urlsString")
                        },
                        onStarshipClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.STARSHIPS.name}?urls=$urlsString")
                        },
                        onVehicleClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.VEHICLES.name}?urls=$urlsString")
                        },
                        onSpeciesClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.SPECIES.name}?urls=$urlsString")
                        }
                    )
                }

                composable(
                    route = "personDetail/{url}",
                    arguments = listOf(navArgument("url") { type = NavType.StringType })
                ) { backStackEntry ->
                    val url = backStackEntry.arguments?.getString("url") ?: ""
                    PersonDetailScreen(
                        personUrl = Uri.decode(url),
                        viewModel = viewModel,
                        onFilmClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.FILMS.name}?urls=$urlsString")
                        },
                        onSpeciesClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.SPECIES.name}?urls=$urlsString")
                        },
                        onStarshipClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.STARSHIPS.name}?urls=$urlsString")
                        },
                        onVehicleClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.VEHICLES.name}?urls=$urlsString")
                        },
                        onHomeworldClick = { homeworldUrl ->
                            val encodedUrl = Uri.encode(homeworldUrl)
                            navController.navigate("planetDetail/$encodedUrl")
                        }
                    )
                }

                composable(
                    route = "planetDetail/{url}",
                    arguments = listOf(navArgument("url") { type = NavType.StringType })
                ) { backStackEntry ->
                    val url = backStackEntry.arguments?.getString("url") ?: ""
                    PlanetDetailScreen(
                        planetUrl = Uri.decode(url),
                        viewModel = viewModel,
                        onResidentClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.PEOPLE.name}?urls=$urlsString")
                        },
                        onFilmClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.FILMS.name}?urls=$urlsString")
                        }
                    )
                }

                composable(
                    route = "speciesDetail/{url}",
                    arguments = listOf(navArgument("url") { type = NavType.StringType })
                ) { backStackEntry ->
                    val url = backStackEntry.arguments?.getString("url") ?: ""
                    SpeciesDetailScreen(
                        speciesUrl = Uri.decode(url),
                        viewModel = viewModel,
                        onPeopleClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.PEOPLE.name}?urls=$urlsString")
                        },
                        onFilmClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.FILMS.name}?urls=$urlsString")
                        },
                        onHomeworldClick = { homeworldUrl ->
                            val encodedUrl = Uri.encode(homeworldUrl)
                            navController.navigate("planetDetail/$encodedUrl")
                        }
                    )
                }

                composable(
                    route = "starshipDetail/{url}",
                    arguments = listOf(navArgument("url") { type = NavType.StringType })
                ) { backStackEntry ->
                    val url = backStackEntry.arguments?.getString("url") ?: ""
                    StarshipDetailScreen(
                        starshipUrl = Uri.decode(url),
                        viewModel = viewModel,
                        onPilotClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.PEOPLE.name}?urls=$urlsString")
                        },
                        onFilmClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.FILMS.name}?urls=$urlsString")
                        }
                    )
                }

                composable(
                    route = "vehicleDetail/{url}",
                    arguments = listOf(navArgument("url") { type = NavType.StringType })
                ) { backStackEntry ->
                    val url = backStackEntry.arguments?.getString("url") ?: ""
                    VehicleDetailScreen(
                        vehicleUrl = Uri.decode(url),
                        viewModel = viewModel,
                        onPilotClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.PEOPLE.name}?urls=$urlsString")
                        },
                        onFilmClick = { urls ->
                            val urlsString = urls.joinToString(",")
                            navController.navigate("dataList/${Fetchable.FILMS.name}?urls=$urlsString")
                        }
                    )
                }
            }
        }
    }
}

package uk.co.willdale.starwarsapp.Initial

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.ListItem
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import uniffi.starwars.Fetchable
import uniffi.starwars.allFetchable

@Composable
fun CategoryListScreen(onCategoryClick: (Fetchable) -> Unit) {
    val categories = allFetchable()
    LazyColumn(modifier = Modifier.fillMaxSize()) {
        items(categories) { fetchable ->
            ListItem(
                headlineContent = { Text(fetchable.displayName()) },
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { onCategoryClick(fetchable) }
            )
            HorizontalDivider()
        }
    }
}

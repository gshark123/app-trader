SELECT asa.name,
			asa.price::money,
			asa.rating AS app_store_rating,
			ROUND(AVG(asa.review_count::numeric)) AS app_store_avg_review,
			ROUND((asa.rating * 2) + 1) AS asa_life_exp,
			psa.price::money,
			psa.rating AS play_store_rating,
			ROUND(AVG(psa.review_count)) AS play_store_avg_review,
			ROUND((psa.rating * 2) + 1) AS psa_life_exp
		FROM play_store_apps AS psa
			INNER JOIN
			app_store_apps AS asa
			ON regexp_replace(psa.name, '[:-].*', '') = regexp_replace(asa.name, '[:-].*', '')
		WHERE LOWER(asa.primary_genre) LIKE 'game%'
		AND LOWER(psa.category) LIKE 'game%'
		AND asa.rating > (SELECT AVG(asa.rating) FROM play_store_apps AS psa
			INNER JOIN
			app_store_apps AS asa
			ON regexp_replace(psa.name, '[:-].*', '') = regexp_replace(asa.name, '[:-].*', ''))
		AND psa.rating > (SELECT AVG(psa.rating) FROM play_store_apps AS psa
			INNER JOIN
			app_store_apps AS asa
			ON regexp_replace(psa.name, '[:-].*', '') = regexp_replace(asa.name, '[:-].*', ''))
		GROUP BY asa.name, asa.price, app_store_rating, psa.price, play_store_rating
		ORDER BY asa.rating DESC;
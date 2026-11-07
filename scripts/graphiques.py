"""Génère deux graphiques à partir des résultats des requêtes 10 et 12.

Usage : python scripts/graphiques.py  (CSV dans data/, séparateur ';')
Dépendances : pandas, matplotlib
"""
import sqlite3
from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "images" / "graphiques"
OUT.mkdir(parents=True, exist_ok=True)

contrat = pd.read_csv(ROOT / "data" / "Contrat.csv", sep=";", dtype=str, encoding="utf-8-sig")
region = pd.read_csv(ROOT / "data" / "Region.csv", sep=";", dtype=str, encoding="utf-8-sig")
contrat["Prix_cotisation_mensuel"] = contrat["Prix_cotisation_mensuel"].astype(float)

con = sqlite3.connect(":memory:")
contrat.to_sql("Contrat", con, index=False)
region.to_sql("Region", con, index=False)

NAVY, ORANGE, GREY = "#14213d", "#b34700", "#c9ced8"
plt.rcParams.update({"font.family": "DejaVu Sans", "axes.spines.top": False, "axes.spines.right": False})

# Requête 12 : contrats par région
q12 = """
SELECT r.reg_nom AS region, COUNT(c.Type_contrat) AS contrats
FROM Contrat c INNER JOIN Region r ON c.Code_dep_code_commune = r.Code_dep_code_commune
GROUP BY r.reg_nom ORDER BY contrats DESC;
"""
d12 = pd.read_sql(q12, con).sort_values("contrats")
fig, ax = plt.subplots(figsize=(9, 6))
colors = [ORANGE if r == "Ile-de-France" else NAVY for r in d12["region"]]
ax.barh(d12["region"], d12["contrats"], color=colors)
for y, v in enumerate(d12["contrats"]):
    ax.text(v + 150, y, f"{v:,}".replace(",", " "), va="center", fontsize=9)
ax.set_title("Nombre de contrats par région (requête 12)", loc="left", fontweight="bold", color=NAVY)
ax.set_xlabel("Contrats")
fig.tight_layout()
fig.savefig(OUT / "contrats_par_region.png", dpi=150)
plt.close(fig)

# Requête 10 : top 10 des départements par cotisation moyenne
q10 = """
SELECT r.dep_nom_num AS departement, AVG(c.Prix_cotisation_mensuel) AS prix_moyen
FROM Contrat c INNER JOIN Region r ON c.Code_dep_code_commune = r.Code_dep_code_commune
GROUP BY r.dep_nom_num ORDER BY prix_moyen DESC LIMIT 10;
"""
d10 = pd.read_sql(q10, con).sort_values("prix_moyen")
moyenne = contrat["Prix_cotisation_mensuel"].mean()
fig, ax = plt.subplots(figsize=(9, 6))
colors = [ORANGE if "Paris" in d else NAVY for d in d10["departement"]]
ax.barh(d10["departement"], d10["prix_moyen"], color=colors)
ax.axvline(moyenne, color=GREY, linestyle="--", label=f"Moyenne nationale : {moyenne:.2f} €".replace(".", ","))
ax.legend(loc="lower right", frameon=False)
for y, v in enumerate(d10["prix_moyen"]):
    ax.text(v + 0.3, y, f"{v:.2f} €".replace(".", ","), va="center", fontsize=9)
ax.set_title("10 départements à la cotisation mensuelle moyenne la plus élevée (requête 10)", loc="left", fontweight="bold", color=NAVY, fontsize=11)
ax.set_xlabel("Cotisation mensuelle moyenne (€)")
fig.tight_layout()
fig.savefig(OUT / "top10_cotisation_departements.png", dpi=150)
plt.close(fig)
print("OK")

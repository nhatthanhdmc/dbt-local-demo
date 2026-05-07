import pandas as pd
import numpy as np
import uuid
import os
import random
from datetime import datetime, timedelta

# =========================================================
# CONFIG
# =========================================================
np.random.seed(42)
random.seed(42)

os.makedirs("seeds", exist_ok=True)


# =========================================================
# HELPER FUNCTIONS
# =========================================================
def generate_yyyymmdd_dates(start_date, num_days):
    """
    Generate list date dạng integer YYYYMMDD
    Example:
    20240101
    """
    base = datetime.strptime(start_date, "%Y-%m-%d")
    dates = []

    for i in range(num_days):
        dt = base + timedelta(days=i)
        dates.append(int(dt.strftime("%Y%m%d")))

    return dates


# date pool cho tháng Jan 2024
monthly_dates = generate_yyyymmdd_dates("2024-01-01", 31)

# snapshot dates
data_dts = [20240101, 20240131]


# =========================================================
# 1. BRANCH DIMENSION
# =========================================================
n_branches = 50

branches = pd.DataFrame({
    "branchnbr": range(1000, 1000 + n_branches),
    "branch_nm": [f"ACB - PGD {i}" for i in range(n_branches)],
    "cluster_nm": np.random.choice(
        ["CUM ACB - CN HCM", "CUM ACB - CN HN", "CUM ACB - CN DONG NAI"],
        n_branches
    ),
    "region_nm": np.random.choice(
        ["VUNG 1", "VUNG 2", "VUNG 3"],
        n_branches
    ),
    "province_nm": np.random.choice(
        ["HO CHI MINH", "HA NOI", "DONG NAI", "BINH DUONG"],
        n_branches
    )
})

branches.to_csv("seeds/mock_stg_qlbh_chinhanh.csv", index=False)
print("Generated branches")


# =========================================================
# 2. CUSTOMER DEMOGRAPHICS
# =========================================================
n_customers = 1000

cust_cds = [str(uuid.uuid4()) for _ in range(n_customers)]
uuids = [str(uuid.uuid4()) for _ in range(n_customers)]

demographics = []

for dt in data_dts:
    df_demo = pd.DataFrame({
        "data_dt": dt,
        "cust_cd": cust_cds,
        "uuid": uuids,
        "active_status": np.random.choice(
            ["ACTIVE", "INACTIVE"],
            n_customers,
            p=[0.8, 0.2]
        ),
        "service_segment": np.random.choice(
            ["VIP", "Mass", "Priority"],
            n_customers
        ),
        "cif_open_dt": np.random.choice(
            generate_yyyymmdd_dates("2020-01-01", 1000),
            n_customers
        ),
        "branch_nbr": np.random.choice(
            branches["branchnbr"],
            n_customers
        ),
        "is_emp": np.random.choice(
            ["Y", "N"],
            n_customers,
            p=[0.05, 0.95]
        ),
        "gender": np.random.choice(
            ["M", "F"],
            n_customers
        ),
        "datebirth": "1990-01-01",
        "marital_status": "Single",
        "education_level": "University",
        "domicile_country": "VN"
    })

    demographics.append(df_demo)

pd.concat(demographics).to_csv(
    "seeds/mock_stg_cust_demographics.csv",
    index=False
)

print("Generated customers")


# =========================================================
# 3. CARD MASTER
# =========================================================
n_cards = 1500

card_ids = [str(uuid.uuid4()) for _ in range(n_cards)]

cards = pd.DataFrame({
    "card_id_hktmo": card_ids,
    "client_number_hktmo": np.random.choice(cust_cds, n_cards),
    "lvl_1": np.random.choice(
        ["Credit", "Debit"],
        n_cards
    ),
    "lvl_2": np.random.choice(
        [
            "Credit Platinum",
            "Debit Standard",
            "Credit Signature",
            "Credit Gold"
        ],
        n_cards
    ),
    "lvl_3": "Visa",
    "lvl_4": "None",
    "from_date": "2024-01-01"
})

cards.to_csv("seeds/mock_stg_card_info.csv", index=False)
print("Generated cards")


# =========================================================
# 4. PRODUCT BALANCES
# =========================================================
balances = []

for dt in data_dts:
    df_bal = pd.DataFrame({
        "cust_cd": cust_cds,
        "data_dt": dt,
        "casa_bal": np.random.uniform(
            0,
            100_000_000,
            n_customers
        ).astype(int),
        "term_deposit_bal": np.random.choice(
            [0, 50_000_000, 100_000_000],
            n_customers
        ),
        "toi_amt": np.random.uniform(
            0,
            1_000_000,
            n_customers
        ).astype(int)
    })

    balances.append(df_bal)

pd.concat(balances).to_csv(
    "seeds/mock_stg_pj_clm_product.csv",
    index=False
)

print("Generated balances")


# =========================================================
# 5. CHURN PREDICTIONS
# =========================================================
churn = []

for dt in data_dts:
    df_churn = pd.DataFrame({
        "cust_cd": cust_cds,
        "data_dt": dt,
        "churn_probability": np.random.uniform(
            0,
            1,
            n_customers
        ).round(4)
    })

    churn.append(df_churn)

pd.concat(churn).to_csv(
    "seeds/mock_stg_churn_predictions.csv",
    index=False
)

print("Generated churn predictions")


# =========================================================
# 6. APP LOGS
# =========================================================
n_logs = 8000

logs = pd.DataFrame({
    "uuid": np.random.choice(uuids, n_logs),
    "event_nm": np.random.choice(
        [
            "ins_login_success",
            "ins_login_fail",
            "transfer_click"
        ],
        n_logs,
        p=[0.7, 0.1, 0.2]
    ),
    "event_tm": np.random.choice(
        monthly_dates,
        n_logs
    ),
    "data_dt": 20240131,
    "e_c_ins_payment_option": np.nan
})

logs.to_csv(
    "seeds/mock_stg_insider_combine_view_churn_model.csv",
    index=False
)

print("Generated app logs")


# =========================================================
# 7. BANK TRANSACTIONS
# =========================================================
n_bank_txns = 15000

bank_txns = pd.DataFrame({
    "acct_nbr": [
        str(uuid.uuid4())[:15]
        for _ in range(n_bank_txns)
    ],
    "rtxn_nbr": range(1, n_bank_txns + 1),
    "cust_cd": np.random.choice(
        cust_cds,
        n_bank_txns
    ),
    "tran_amt": np.random.uniform(
        -5_000_000,
        5_000_000,
        n_bank_txns
    ).astype(int),
    "post_dt": np.random.choice(
        monthly_dates,
        n_bank_txns
    ),
    "data_dt": 20240131,
    "cust_type": "CN",
    "mjaccttypcd": np.random.choice(
        ["SAV", "CK"],
        n_bank_txns
    ),
    "rtxnsourcecd": np.random.choice(
        ["ONLI", "MAPP", "WWW", "BRANCH"],
        n_bank_txns,
        p=[0.4, 0.4, 0.1, 0.1]
    ),
    "accttypcd": "TGTT",
    "term_cd": "KKH",
    "branch_acct": np.random.choice(
        branches["branchnbr"],
        n_bank_txns
    ),
    "currencycd": "VND",
    "miaccttypcd": "G270",
    "mjmidesc": "TKTT FIRST KHTN (CN) VND",
    "branch_thgd": np.random.choice(
        branches["branchnbr"],
        n_bank_txns
    ),
    "is_cash": 0,
    "created_at": np.random.choice(
        monthly_dates,
        n_bank_txns
    ),
    "intrtxndesctext": np.random.choice(
        [
            "CHUYEN KHOAN QUA APP",
            "THANH TOAN XANH SM",
            "MUA TREN SHOPEE",
            "BOOK PHONG AGODA",
            "XEM PHIM CGV",
            "CUOC GRAB"
        ],
        n_bank_txns
    ),
    "mcc": np.random.choice(
        [
            "5411",
            "5812",
            "4121",
            "7311",
            "4900",
            "4722",
            "0000"
        ],
        n_bank_txns
    )
})

bank_txns.to_csv(
    "seeds/mock_stg_flat_transaction_churn_model.csv",
    index=False
)

print("Generated bank transactions")


# =========================================================
# 8. CARD TRANSACTIONS
# =========================================================
n_card_txns = 12000

card_txns = pd.DataFrame({
    "doc_id": [
        str(uuid.uuid4())
        for _ in range(n_card_txns)
    ],
    "card_id_hktmo": np.random.choice(
        card_ids,
        n_card_txns
    ),
    "posting_date": np.random.choice(
        monthly_dates,
        n_card_txns
    ),
    "billing_amount": np.random.uniform(
        50_000,
        10_000_000,
        n_card_txns
    ).astype(int),
    "txn_typ": "Retail",
    "mcc": np.random.choice(
        ["5411", "5812", "4121"],
        n_card_txns
    ),
    "trans_details": "THANH TOAN POS",
    "merchant_id": np.random.choice(
        ["GRAB", "SHOPEE", "XANHSM"],
        n_card_txns
    )
})

card_txns.to_csv(
    "seeds/mock_stg_fin_transaction.csv",
    index=False
)

print("Generated card transactions")


print("\nHoàn tất tạo data cho dbt seeds!")
print("Tất cả cột date hiện đã dùng format YYYYMMDD.")
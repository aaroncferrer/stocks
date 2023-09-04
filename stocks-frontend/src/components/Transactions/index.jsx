import axios from "axios";
import { useMemo, useEffect, useState } from "react";
import Table from '../../utils/Table';

function Transactions({ currentUser }) {
    const [transactions, setTransactions] = useState([]);

    useEffect(() => {
        const fetchTransactions = async () => {
            try {
                const token = currentUser.token;
                const response = await axios.get('http://localhost:3000/transactions', {
                    headers: {
                        Authorization: `Bearer ${token}`
                    }
                });
                const formattedTransactions = response.data.map(transaction => ({
                    ...transaction,
                    total_price: parseFloat(transaction.total_price).toFixed(2)
                }));
                setTransactions(formattedTransactions);
            } catch (error) {
                console.error('Error fetching transactions', error);
            }
        }

        fetchTransactions();
    }, [currentUser.token]);

    const columns = useMemo(() => [
        {
            Header: "ID",
            accessor: "id",
        },
        {
            Header: "Stock",
            accessor: "stock.symbol",
        },
        {
            Header: "Stock Price",
            accessor: "stock.price_amount",
        },
        {
            Header: "Action",
            accessor: "action",
        },
        {
            Header: "Quantity",
            accessor: "quantity",
        },
        {
            Header: "Total Price",
            accessor: "total_price",
        },
        {
            Header: "Trader",
            accessor: (row) => `${row.trader.first_name} ${row.trader.last_name}`
        },
    ], []);

    return(
        <Table 
            columns={columns}
            data={transactions}
            table_header={"TRANSACTIONS"}
        />
    );
}

export default Transactions;

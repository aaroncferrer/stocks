import axios from "axios";
import { useMemo, useEffect, useState } from "react";
import Table from '../../utils/Table';

function Portfolios({ currentUser }) {
    const [portfolios, setPortfolios] = useState([]);

    useEffect(() => {
        const fetchPortfolios = async () => {
            try {
                const token = currentUser.token;
                const response = await axios.get('http://localhost:3000/portfolios', {
                    headers: {
                        Authorization: `Bearer ${token}`
                    }
                });
                setPortfolios(response.data);
            } catch (error) {
                console.error('Error fetching portfolios', error);
            }
        }

        fetchPortfolios();
    }, [currentUser.token]);

    const columns = useMemo(() => [
        {
            Header: "Stock Symbol",
            accessor: "stock_symbol",
        },
        {
            Header: "Stock Name",
            accessor: "stock.name",
        },
        {
            Header: "Stock Price",
            accessor: "current_price",
        },
        {
            Header: "As of",
            accessor: (row) => new Date(row.stock.as_of).toLocaleString()
        },
        {
            Header: "Qty Owned",
            accessor: "quantity",
        },
        {
            Header: "Total Price",
            accessor: (row) => `PHP ${row.total_amount}`,
        }
    ], []);

    return(
        <Table 
            columns={columns}
            data={portfolios}
            table_header={"PORTFOLIOS"}
        />
    );
}

export default Portfolios;

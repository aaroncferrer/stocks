import axios from "axios";
import { useMemo, useEffect, useState } from "react";
import Table from '../../utils/Table';

function Portfolios({ currentUser, setCurrentUser }) {
    const [portfolios, setPortfolios] = useState([]);
    const [showStockModal, setShowStockModal] = useState(false);
    const [selectedStock, setSelectedStock] = useState(null);
    const [portfolioUpdated, setPortfolioUpdated] = useState(false);

    const fetchPortfolioDetails = async (id) => {
        try {
            const token = currentUser.token;
            const response = await axios.get(`http://localhost:3000/portfolios/${id}`, {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });
            console.log(response.data);
            const portfolioData = response.data;
            setSelectedStock({
                name: portfolioData.stock.name,
                symbol: portfolioData.stock.symbol,
                price_amount: portfolioData.stock.price_amount,
                price_currency: portfolioData.stock.price_currency,
                percent_change: portfolioData.stock.percent_change,
                as_of: new Date(portfolioData.stock.as_of).toLocaleString()
            });
        } catch (error) {
            console.error('Error fetching stock details', error);
        }
    };

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
    }, [currentUser.token, portfolioUpdated]);

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
            Header: "Shares",
            accessor: "quantity",
        },
        {
            Header: "Total Price",
            accessor: (row) => `PHP ${row.total_amount.toFixed(2)}`
        }
    ], []);

    return(
        <Table 
            currentUser={currentUser}
            setCurrentUser={setCurrentUser}
            columns={columns}
            data={portfolios}
            table_header={"PORTFOLIOS"}
            showStockModal={showStockModal}
            selectedStock={selectedStock}
            setShowModal={setShowStockModal}
            fetchData={fetchPortfolioDetails}
            setPortfolioUpdated={setPortfolioUpdated}
        />
    );
}

export default Portfolios;

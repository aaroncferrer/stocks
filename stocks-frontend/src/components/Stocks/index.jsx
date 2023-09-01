import axios from "axios";
import { useMemo, useEffect, useState } from "react";
import { BsArrowUp, BsArrowDown } from 'react-icons/bs';
import { GoDash } from 'react-icons/go';
import Table from '../../utils/Table';

function Stocks({ currentUser }) {
    const [stocks, setStocks] = useState([]);
    const [date, setDate] = useState('');
    const [showStockModal, setShowStockModal] = useState(false);
    const [selectedStock, setSelectedStock] = useState(null);

    const fetchStockDetails = async (id) => {
        try {
            const token = currentUser.token;
            const response = await axios.get(`http://localhost:3000/stocks/${id}`, {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });
            setSelectedStock(response.data);
        } catch (error) {
            console.error('Error fetching stock details', error);
        }
    };
    
    useEffect(() => {
        const fetchStocks = async () => {
            try {
                const token = currentUser.token;
                const response = await axios.get('http://localhost:3000/stocks', {
                    headers: {
                        Authorization: `Bearer ${token}`
                    }
                });
                const sortedStocks = response.data.sort((a, b) => a.id - b.id);
                setStocks(sortedStocks);
                setDate(new Date(response.data[0].as_of).toLocaleString());
            } catch (error) {
                console.error('Error fetching stocks', error);
            }
        }

        fetchStocks();
    }, [currentUser.token]);

    const columns = useMemo(() => [
        {
            Header: "",
            accessor: "symbol_icon",
            Cell: ({ row }) => {
                const percentChange = row.original.percent_change;
                if (percentChange > 0) {
                    return <BsArrowUp style={{ color: "green" }} className='percent_symbol' />;
                } else if (percentChange < 0) {
                    return <BsArrowDown style={{ color: "red" }} className='percent_symbol' />;
                } else {
                    return <GoDash style={{ color: "yellow" }} className='percent_symbol' />;
                }
            },
        },
                {
            Header: "",
            accessor: "id",
        },
        {
            Header: "Symbol",
            accessor: "symbol",
        },
        {
            Header: "Name",
            accessor: "name",
        },
        {
            Header: "Price",
            accessor: "price_amount",
        },
        {
            Header: "Change",
            accessor: "percent_change",
        },
        {
            Header: "Volume",
            accessor: "volume",
        },
    ], []);

    return(
        <Table 
            columns={columns}
            data={stocks}
            table_header={"STOCKS"}
            date={date}
            showStockModal={showStockModal}
            selectedStock={selectedStock}
            setShowModal={setShowStockModal}
            fetchData={fetchStockDetails}
        />
    );
}

export default Stocks;

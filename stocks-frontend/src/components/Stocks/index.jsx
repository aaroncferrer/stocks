import './stocks.css'

import axios from "axios";
import { useMemo, useEffect, useState } from "react";
import { useTable, usePagination, useGlobalFilter } from 'react-table'
import { BsArrowUp, BsArrowDown, BsArrowLeft, BsArrowRight } from 'react-icons/bs';
import { GoDash } from 'react-icons/go';

function Stocks({ currentUser }) {
    const [stocks, setStocks] = useState([]);
    const [date, setDate] = useState('');
    
    useEffect(() => {
        const fetchStocks = async () => {
            try {
                const token = currentUser.token;
                const response = await axios.get('http://localhost:3000/stocks', {
                    headers: {
                        Authorization: `Bearer ${token}`
                    }
                });
                setStocks(response.data);
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

    const {
        getTableProps,
        getTableBodyProps,
        headerGroups,
        page,
        prepareRow,
        state: { pageIndex, globalFilter },
        canPreviousPage,
        canNextPage,
        pageOptions,
        gotoPage,
        nextPage,
        previousPage,
        setGlobalFilter
    } = useTable(
        { 
            columns, 
            data: stocks,
            initialState: { pageIndex: 0, pageSize: 11 }
        },
        useGlobalFilter,
        usePagination
    );

    return(
        <>
            <div className="stocks_container">

                <div style={{display: "flex", justifyContent: "space-between", alignItems: "center"}}>
                    <h1>STOCKS</h1>
                    <div className="search_container">
                        <input
                            type="text"
                            value={globalFilter || ''}
                            onChange={(e) => setGlobalFilter(e.target.value)}
                            placeholder="Search by name..."
                        />
                        <span>As of: {date}</span>
                    </div>
                </div>

                <div className="table_container">
                <table className='stocks_table' {...getTableProps()}>
                    <thead>
                        {headerGroups.map((headerGroup) => (
                            <tr {...headerGroup.getHeaderGroupProps()}>
                                {headerGroup.headers.map((column) => (
                                    <th {...column.getHeaderProps()}>
                                        {column.render("Header")}
                                    </th>
                                ))}
                            </tr>
                        ))}
                    </thead>
                    <tbody {...getTableBodyProps()}>
                        {page.map((row) => {
                            prepareRow(row)
                            return(
                                <tr {...row.getRowProps()}>
                                    {row.cells.map((cell) => (
                                        <td {...cell.getCellProps()}>
                                            {cell.render("Cell")}
                                        </td>
                                    ))}
                                </tr>
                            )
                        })}
                    </tbody>
                </table>
                </div>

                {/* Pagination controls */}
                <div className="pagination">
                    <button className='btns btn_secondary' onClick={() => previousPage()} disabled={!canPreviousPage}>
                        <BsArrowLeft />
                    </button>
                    <button className='btns btn_secondary' onClick={() => nextPage()} disabled={!canNextPage}>
                        <BsArrowRight />
                    </button>
                    <span>Page {pageIndex + 1} of {pageOptions.length}</span>
                    <span>|</span>
                    <div>
                        <span>GO TO PAGE : </span> 
                        <input
                            type="number"
                            defaultValue={pageIndex + 1}
                            onChange={(e) => {
                                const page = e.target.value ? Number(e.target.value) - 1 : 0;
                                gotoPage(page);
                            }}
                            style={{ width: '50px', textAlign: "center" }}
                        />
                    </div>
                </div>

            </div>
        </>
    );
}

export default Stocks;

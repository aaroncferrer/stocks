import React from "react";
import { useTable, usePagination, useGlobalFilter, useSortBy } from 'react-table';
import { BsArrowLeft, BsArrowRight } from 'react-icons/bs';
import StockModal from "../../components/Modals/TableModal";
import AuthModal from "../../components/Modals/AuthModal";
import './table.css'

function Table(props) {
    const { currentUser, columns, data, table_header, date, setShowModal, fetchData, showStockModal, selectedStock, showTraderModal, selectedTrader, showCreateTrader, setShowCreateTrader, traders,updateTrader } = props;

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
            data,
            initialState: {
                pageIndex: 0,
                pageSize: 11,
                sortBy: [
                    {
                        id: 'id',
                        desc: false, // Ascending order
                    },
                ],
            },
        },
    useGlobalFilter,
    useSortBy,
    usePagination 
    );

    return (
        <>
            <div className="utilTable_container">

                {showStockModal && (
                    <StockModal
                        showStockModal={showStockModal}
                        setShowStockModal={setShowModal}
                        stockData={selectedStock}
                    />
                )}

                {showTraderModal && (
                    <StockModal
                        showTraderModal={showTraderModal}
                        setShowTraderModal={setShowModal}
                        traderData={selectedTrader}
                        updateTrader={updateTrader}
                    />
                )}

                {showCreateTrader && (
                    <AuthModal
                        currentUser={currentUser} 
                        traders={traders}
                        showCreateTrader={showCreateTrader}
                        setShowCreateTrader={setShowCreateTrader}
                    />
                )}
                    
                <div style={{display: "flex", justifyContent: "space-between", alignItems: "center"}}>
                    <h1>{table_header}</h1>
                    <div className="search_container">
                        <input
                            type="text"
                            value={globalFilter || ''}
                            onChange={(e) => setGlobalFilter(e.target.value)}
                            placeholder="Search by name..."
                        />
                        {date && <span>As of: {date}</span>}
                        {table_header === "TRADERS" && 
                        <button
                            style={{padding: "0"}}     
                            className="btns btn_secondary" 
                            onClick={() => setShowCreateTrader(true)}
                        >
                            Create Trader
                        </button>}
                    </div>
                </div>

                <div className="table_container">
                <table className='utilTable' {...getTableProps()}>
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
                                <tr
                                    onClick={() => {
                                        table_header !== "TRANSACTIONS" ? (
                                            setShowModal(true), 
                                            fetchData(row.original.id)
                                        ) : null;
                                    }}
                                    {...row.getRowProps()}
                                >
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

export default Table;
